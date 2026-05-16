#tidy3d_effective2D_helper.py

import numpy as np
import tidy3d as td
import matplotlib.pyplot as plt
from tidy3d.plugins.dispersion import FastDispersionFitter

import scipy.interpolate
from tidy3d.plugins.mode.web import run as run_mode_solver


def var_eps_eff(point, ref_point, sim, wavelength=1.55, inf=1000, min_n=1, remote=False):
    """
    To calculate the vertical slab mode at 'ref_point', we will create a 2D slice of the given simulation at
    'ref_point' that extends in the yz plane infinitely, ensuring that it captures the entire permittivity
    profile. Then, to find the 1D mode profile, we use the Tidy3D ModeSolver on a plane at 'ref_point' that
    extends infinitely in the xz plane. This results in the ModeSolver operating on the intersecting line
    at 'ref_point' that covers its entire z profile. We then use this to solve for n_eff and M in the above
    formula.

    The min_n parameter is set to ensure that the calculated refractive index is at least 1. This
    calculation can well end up with a value less than 1, as mentioned in the paper. To ensure that the
    returned refractive index is physical, we set min_n to 1 by default.

    There is also the option to use the remote mode solver if the user desires greater accuracy.
    """
    freq = td.C_0 / wavelength

    sim_2d_center = (
        ref_point[0],
        ref_point[1],
        0,
    )  # given a 3D sim, we update the center to create our 2D slice
    sim_2d_size = (
        0,
        inf,
        inf,
    )  # we ensure the 2D span of the simulation in the yz plane captures everything

    # now we create the 2D simulation, keeping the structures and updating the boundary conditions
    sim_2d = sim.updated_copy(
        center=sim_2d_center,
        size=sim_2d_size,
        sources=[],
        monitors=[],
        symmetry=(0, 0, 0),
        boundary_spec=sim.boundary_spec.updated_copy(x=td.Boundary.periodic()),
    )

    # Now we solve for the mode at 'ref_point':
    # We create the plane in xz that we'll use to examine the mode in z
    mode_solver_plane = td.Box(center=sim_2d.center, size=(td.inf, 0, td.inf))
    # Now we define the mode solver using this plane. We need only solve for one mode here, hence the ModeSpec
    mode_solver = td.plugins.mode.ModeSolver(
        simulation=sim_2d, plane=mode_solver_plane, mode_spec=td.ModeSpec(num_modes=1), freqs=[freq]
    )

    # Note that here the mode solving is done locally. For users desiring more accuracy, the remote mode
    # solver should be used.
    if remote:
        mode_data_ref = run_mode_solver(mode_solver)
    else:
        mode_data_ref = mode_solver.solve()

    # get n_eff from the solver
    n_eff = mode_data_ref.n_eff.item()
    if point == ref_point:
        return n_eff**2  # if point is the reference point, the integral is 0

    # get z permittivity profile at 'ref_point'
    x, y = ref_point
    eps_ref = sim.epsilon(
        box=td.Box(center=(x, y, list(sim.center)[2]), size=(0, 0, td.inf)), freq=freq
    )

    # get z permittivity profile at 'point'
    x, y = point
    eps = sim.epsilon(
        box=td.Box(center=(x, y, list(sim.center)[2]), size=(0, 0, td.inf)), freq=freq
    )

    eps_dif = np.squeeze(eps.values) - np.squeeze(eps_ref.values)

    # get M at the same z coordinates as those of (eps - eps_ref) so we can integrate their product
    z_coords = eps_ref.z.values
    mode_profile = mode_data_ref.Ex
    Mz2 = scipy.interpolate.interp1d(
        x=mode_profile.z.values, y=np.abs(np.squeeze(mode_profile.values)) ** 2
    )
    m_values = Mz2(z_coords)

    # calculate integrals
    num, denom = (
        np.trapezoid(y=eps_dif * m_values, x=z_coords),
        np.trapezoid(y=m_values, x=z_coords),
    )

    if n_eff**2 + num / denom < min_n:
        return min_n
    return n_eff**2 + num / denom

###########################################################################################################################################################################

def approximate_material(
    sim_3D, approx_point, ref_point, spectrum, min_n=1, plot=False, **fit_kwargs
):
    eps = []
    for wl in spectrum:  # at every [step]th wavelength, calculate the effective permittivity
        eps.append(var_eps_eff(approx_point, ref_point, sim_3D, wavelength=wl, min_n=min_n))

    # fit the materials with the FastDispersionFitter using the calculated effective permittivities
    e1, e2 = np.real(eps), np.imag(eps)
    n = np.sqrt((np.sqrt(e1**2 + e2**2) + e1) / 2)
    k = np.sqrt((np.sqrt(e1**2 + e2**2) - e1) / 2)
    fitter = FastDispersionFitter(wvl_um=spectrum, n_data=n, k_data=k)

    # create the mediums using the material fit
    fit_kwargs.setdefault("min_num_poles", 1)
    medium, rms_error = fitter.fit(**fit_kwargs)

    if plot:
        # plot the material fit
        fig, ax = plt.subplots(1, 1, figsize=(3, 3))
        fitter.plot(medium, ax=ax)
        ax.set_title("Medium")
        plt.show()

    return medium

###########################################################################################################################################################################

def create_2D_sim(sim_3D, new_mediums):
    new_structures = []
    for structure in sim_3D.structures:
        new_structures.append(structure.updated_copy(medium=new_mediums[0]))

    new_size = list(sim_3D.size)
    new_size[2] = 0

    new_symmetry = (0, 0, 0)

    # Only move centers to z=0, keep sizes as-is
    new_sources = []
    for src in sim_3D.sources:
        new_sources.append(src.updated_copy(
            center=(src.center[0], src.center[1], 0),
        ))

    new_monitors = []
    for mon in sim_3D.monitors:
        new_monitors.append(mon.updated_copy(
            center=(mon.center[0], mon.center[1], 0),
        ))

    sim_2D = sim_3D.updated_copy(
        size=new_size,
        center=(sim_3D.center[0], sim_3D.center[1], 0),
        structures=new_structures,
        sources=new_sources,
        monitors=new_monitors,
        boundary_spec=sim_3D.boundary_spec.updated_copy(z=td.Boundary.periodic()),
        medium=new_mediums[1],
        symmetry=new_symmetry,
    )

    return sim_2D