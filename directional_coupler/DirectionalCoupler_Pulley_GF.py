
import gdsfactory as gf
import gdsfactory.components as gc
from Straight import Straight
from Bend import Bend
from Pulley import Pulley
from Half_Ring_GF import Half_Ring
import numpy as np

gf.clear_cache()
@gf.cell
def DirectionalCoupler_Pulley(
    TotLengthX = 100.0,
    InLengthX = 50.0,
    LengthY   = 20,
    Radius = 20.0,
    WgWidthIO = 1.0,
    WgWidth = 1.25,
    Gap = 0.4,
    CouplingLength = 20.0,
    BendRadiusIO = 30.0,
    Euler = 1,
    Layer = (2, 0),
):
    DirectionalCouplerPulley = gf.Component()
    
    #-------------------------------------------------------------------------------------------------
    # IO
    #-------------------------------------------------------------------------------------------------
    
    ThetaC = np.degrees(CouplingLength/Radius)

    P = Pulley(Radius=Radius, WgWidth=WgWidthIO, ThetaC=ThetaC, BendRadius=BendRadiusIO, Gap=Gap, InLengthX=0, Euler=Euler, Layer=Layer)
    DYP = P.info["DY"]

    OutLengthX = TotLengthX - InLengthX - DYP

    InX  = DirectionalCouplerPulley << Straight(Length=InLengthX, Width=WgWidthIO, Layer=Layer)
    Arc  = DirectionalCouplerPulley << P
    OutX = DirectionalCouplerPulley << Straight(Length=OutLengthX, Width=WgWidthIO, Layer=Layer)

    #-------------------------------------------------------------------------------------------------
    # HalfRing
    #-------------------------------------------------------------------------------------------------

    HR = DirectionalCouplerPulley << Half_Ring(Radius=Radius, WgWidth=WgWidth,LengthY=LengthY, Layer=Layer)
    
    RingOffsetX = 0
    RingOffsetY = -abs(WgWidth/2-WgWidthIO/2)
    
    HR.move((RingOffsetX,RingOffsetY))
    
    # -------------------------------------
    
    InX.connect("o2",Arc.ports["o1"])
    OutX.connect("o1", Arc.ports["o2"])

    DirectionalCouplerPulley.add_port(name="IN", port=InX.ports["o1"])
    DirectionalCouplerPulley.add_port(name="TH", port=OutX.ports["o2"])
    DirectionalCouplerPulley.add_port(name="CR", port=HR.ports["o1"])
    DirectionalCouplerPulley.add_port(name="BS", port=HR.ports["o2"])

    return DirectionalCouplerPulley

if __name__ == "__main__":
    c = DirectionalCoupler_Pulley()
    c.write_gds("DirectionalCouplerPulley.gds")


