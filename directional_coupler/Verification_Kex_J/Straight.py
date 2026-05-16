import gdsfactory as gf

@gf.cell
def Straight(Length=10, Width = 1, Layer=(1, 0)):
    
    c = gf.Component()
    
    c.add_polygon([(0, 0), (Length, 0), (Length, Width), (0, Width)], layer=Layer)
    
    c.add_port(name="o1", center=(0, Width / 2), width=Width, orientation=180, layer=Layer)
    
    c.add_port(name="o2", center=(Length, Width / 2), width=Width, orientation=0, layer=Layer)
    
    
    return c
