import gdsfactory as gf
import numpy as np

from Straight import Straight
from Bend import Bend

gf.clear_cache()

@gf.cell
def DirectionalCoupler_HalfRing(
    TotLengthX=100.0,
    LengthY=20,
    Radius=25.0,
    WgWidth=1.6,
    WgWidthIO=1.0,
    Gap=0.8,
    Layer=(2, 0),
):
    c = gf.Component()

    # Bus waveguide (centered at origin)
    bus = c << Straight(Length=TotLengthX, Width=WgWidthIO, Layer=Layer)
    bus_center = bus.dcenter
    bus.dmove((-bus_center[0], -bus_center[1]))
    
    HalfRingOffSetY = -Radius - WgWidthIO/2 -WgWidth/2  - Gap

    Bend1 = c << Bend(Radius=Radius, Width=WgWidth, angle=90, Layer=Layer).copy()
    Bend1.rotate(90)
    Bend1.dmove((Radius,HalfRingOffSetY))

    Bend2 = c << Bend(Radius=Radius, Width=WgWidth, angle=90, Layer=Layer).copy()
    Bend2.connect("o1", Bend1.ports["o2"])

    YLeft  = c << Straight(Length=LengthY, Width=WgWidth, Layer=Layer)
    YRight = c << Straight(Length=LengthY, Width=WgWidth, Layer=Layer)

    YLeft.connect("o1", Bend1.ports["o1"])
    YRight.connect("o1", Bend2.ports["o2"])

    return c

if __name__ == "__main__":
    c = DirectionalCoupler_HalfRing()
    c.write_gds("DirectionalCoupler_HalfRing.gds")