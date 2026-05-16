import gdsfactory as gf

@gf.cell
def Bend(Radius = 10, Width = 1, angle = 90, Layer = (1,0), Euler = 0):
    
    c = gf.Component()
    
    if Euler == 1:
        Bend = gf.components.bend_euler(radius=Radius, width=Width, angle=angle, layer=Layer, allow_min_radius_violation=True)
    else:
        Bend = gf.components.bend_circular(radius=Radius, width=Width, angle=angle, layer=Layer, allow_min_radius_violation=True)
        
    Bend_Ref =  c << Bend
    
    c.add_port(name="o1", port = Bend_Ref.ports["o1"])
    
    c.add_port(name="o2", port = Bend_Ref.ports["o2"])
    
    return c