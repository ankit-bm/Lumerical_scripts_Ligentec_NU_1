import gdsfactory as gf
from Bend import Bend
from Straight import Straight

gf.clear_cache()

@gf.cell()
def TopArm(InLengthX, LengthY, CouplingLengthX, WgWidth, Radius, Layer, Euler=1):
    top = gf.Component()

    I     = top << Straight(Length=InLengthX, Width=WgWidth, Layer=Layer)
    Bend1 = top << Bend(Radius=Radius, Width=WgWidth, angle=90, Layer=Layer, Euler=Euler)
    Y     = top << Straight(Length=LengthY, Width=WgWidth, Layer=Layer)
    Bend2 = top << Bend(Radius=Radius, Width=WgWidth, angle=-90, Layer=Layer, Euler=Euler)
    Lc    = top << Straight(Length=CouplingLengthX, Width=WgWidth, Layer=Layer)
    Bend3 = top << Bend(Radius=Radius, Width=WgWidth, angle=-90, Layer=Layer, Euler=Euler)
    Y2    = top << Straight(Length=LengthY, Width=WgWidth, Layer=Layer)
    Bend4 = top << Bend(Radius=Radius, Width=WgWidth, angle=90, Layer=Layer, Euler=Euler)
    O     = top << Straight(Length=InLengthX, Width=WgWidth, Layer=Layer)

    Bend1.connect("o1", I.ports["o2"])
    Y.connect("o1", Bend1.ports["o2"])
    Bend2.connect("o1", Y.ports["o2"])
    Lc.connect("o1", Bend2.ports["o2"])
    Bend3.connect("o1", Lc.ports["o2"])
    Y2.connect("o1", Bend3.ports["o2"])
    Bend4.connect("o1", Y2.ports["o2"])
    O.connect("o1", Bend4.ports["o2"])

    # Center on Lc
    lc_center = Lc.dcenter
    for inst in top.insts:
        inst.dmove((-lc_center[0], -lc_center[1]))

    top.add_port(name="o1", port=I.ports["o1"])
    top.add_port(name="o2", port=O.ports["o2"])
    return top


@gf.cell()
def DirectionalCoupler(
    InLengthX=60.0,
    LengthY=10.0,
    CouplingLengthX=12.0,
    WgWidth=1.0,
    Radius=25.0,
    Gap=0.4,
    Euler=1,
    Layer=(2, 0),
):
    DC = gf.Component()

    arm = TopArm(
        InLengthX=InLengthX,
        LengthY=LengthY,
        CouplingLengthX=CouplingLengthX,
        WgWidth=WgWidth,
        Radius=Radius,
        Layer=Layer,
        Euler=Euler,
    )

    top = DC << arm
    top.dmove((0, -(Gap / 2 + WgWidth / 2)))

    bot = DC << arm
    bot.dmirror_y(0)
    bot.dmove((0, (Gap / 2 + WgWidth / 2)))

    DC.add_port(name="o1", port=top.ports["o1"])
    DC.add_port(name="o2", port=top.ports["o2"])
    DC.add_port(name="o3", port=bot.ports["o1"])
    DC.add_port(name="o4", port=bot.ports["o2"])
    return DC


if __name__ == "__main__":
    gf.clear_cache()
    c = DirectionalCoupler()
    c.write_gds("DC_test.gds")
    c.plot()