import gdsfactory as gf
import numpy as np

gf.clear_cache()
@gf.cell()
def DirectionalCoupler_Pulley(
    TotLengthX = 300.0,
    InLengthX = 100.0,
    Radius = 50.0,
    WgWidth = 1.0,
    RingWgWidth = 2.0,
    Gap = 0.85,
    ThetaC = 40.0,
    BendRadiusIO = 30.0,
    Euler = 1,
    Layer = (2, 0),
):
    DirectionalCouplerPulley = gf.Component()

    ArcRadius     = Radius + Gap + WgWidth / 2
    HalfTheta_deg = ThetaC / 2.0
    HalfTheta_rad = np.radians(HalfTheta_deg)

    # S-bend type
    if Euler == 1:
        sbend_in  = gf.path.euler(radius=BendRadiusIO, angle=+HalfTheta_deg, p=1.0)
        sbend_out = gf.path.euler(radius=BendRadiusIO, angle=+HalfTheta_deg, p=1.0)
    else:
        sbend_in  = gf.path.arc(radius=BendRadiusIO, angle=+HalfTheta_deg)
        sbend_out = gf.path.arc(radius=BendRadiusIO, angle=+HalfTheta_deg)

    #########################################################################
    # Path : making 1D line and then extrude - Building from left to right
    #########################################################################

    p = gf.path.straight(length=InLengthX)

    arc_start_x = p.points[-1][0]       # X before arc section

    p += sbend_in

    # CoC: perpendicular-right of tangent at end of sbend_in
    x2, y2 = p.points[-1]
    coc_x = x2 + ArcRadius * np.sin(HalfTheta_rad)
    coc_y = y2 - ArcRadius * np.cos(HalfTheta_rad)

    p += gf.path.arc(radius=ArcRadius, angle=-ThetaC)
    p += sbend_out

    Arc_X = p.points[-1][0] - arc_start_x
    OutLengthX = TotLengthX - InLengthX - 2*BendRadiusIO - Arc_X

    p += gf.path.straight(length=OutLengthX)

    WgExtrusion = gf.path.extrude(p, layer=Layer, width=WgWidth)

    #########################################################################
    # Center of Curvature sits at origin
    #########################################################################
    
    I = DirectionalCouplerPulley << WgExtrusion
    I.dmove((-coc_x, -coc_y))

    # DEBUG: cross marker at origin to verify CoC placement
    marker_size = 5.0
    DirectionalCouplerPulley.add_polygon(
        [(-marker_size, -0.2), (marker_size, -0.2),
         (marker_size, 0.2), (-marker_size, 0.2)],
        layer=(98, 0),
    )
    DirectionalCouplerPulley.add_polygon(
        [(-0.2, -marker_size), (0.2, -marker_size),
         (0.2, marker_size), (-0.2, marker_size)],
        layer=(98, 0),
    )

    #########################################################################
    # Ring
    #########################################################################
    RingR = Radius - RingWgWidth/2  # same value you pass to ring()
    Ring = gf.components.ring(radius=RingR, width=RingWgWidth, layer=Layer, angle=180).copy()
    Ring.add_port(name="o1", center=(-RingR, 0), width=RingWgWidth, orientation=270, layer=Layer)
    Ring.add_port(name="o2", center=(RingR, 0), width=RingWgWidth, orientation=270, layer=Layer)

    R = DirectionalCouplerPulley << Ring

    xs = gf.cross_section.cross_section(width=RingWgWidth, layer=Layer)
    I_Ring = DirectionalCouplerPulley << gf.components.straight(length=InLengthX,cross_section=xs)
    I_Ring.rotate(-90)

    O_Ring = DirectionalCouplerPulley << gf.components.straight(length=InLengthX,cross_section=xs)

    I_Ring.connect("o1", R.ports["o1"])
    O_Ring.connect("o1", R.ports["o2"])
    # ------------------------------------------------------------------
    # Ports
    # ------------------------------------------------------------------
    DirectionalCouplerPulley.add_port(name="IN", port=I.ports["o1"])
    DirectionalCouplerPulley.add_port(name="TH", port=I.ports["o2"])

    DirectionalCouplerPulley.add_port(name="CR", port=O_Ring.ports["o2"])
    DirectionalCouplerPulley.add_port(name="BS", port=I_Ring.ports["o2"])

    return DirectionalCouplerPulley

if __name__ == "__main__":
    c = DirectionalCoupler_Pulley()
    c.write_gds("DirectionalCouplerPulley.gds")