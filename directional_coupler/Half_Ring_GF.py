import gdsfactory as gf
import gdsfactory.components as gc
from Straight import Straight
from Bend import Bend

gf.clear_cache()
@gf.cell
def Half_Ring(
    Radius  = 20.0,
    WgWidth = 1.0,
    LengthY = 20.0,
    Layer = (2, 0),
):
    
    c = gf.Component()

    Bend1 = c << Bend(Radius=Radius, Width=WgWidth, angle=90, Layer=Layer)
    Bend1.rotate(90)
    Bend1.movex(Radius)

    Bend2 = c << Bend(Radius=Radius, Width=WgWidth, angle=90, Layer=Layer)
    Bend2.connect("o1", Bend1.ports["o2"])
    
    YLeft  = c << Straight(Length=LengthY, Width=WgWidth, Layer=Layer)
    YRight = c << Straight(Length=LengthY, Width=WgWidth, Layer=Layer)

    YLeft.connect("o1", Bend1.ports["o1"])
    YRight.connect("o1", Bend2.ports["o2"])
    
    c.add_port("o1", port=YLeft.ports["o2"])
    c.add_port("o2", port=YRight.ports["o2"])
    
    return c

if __name__ == "main":
    c = Half_Ring()
    c.plot()
    c.write_gds("Half_Ring_test.gds")