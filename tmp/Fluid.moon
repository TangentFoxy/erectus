-- what kind of usage do I want?

tank = Container(volume):add("O2", 400)
o2_control = Valve(tank, atmosphere, 0) -- rate/area/whatever
-- remember, Containers don't need to be updated, everything else does

fluid = require "fluid"
ls_tank = fluid.Container(volume):add("O2")
fluid.Mix(ls_tank, fluid.vaccum, 0.001)







a = Container(volume):add('co2', 300):add('o2', 100)
Mix(a, Container.vaccum, 0.01) -- rate/volume/area specified (your choice of meaning lol)
Pump(a, b, 1) --rate/volume/area, your choice
Filter(a, b, 0.1) -- rate/volume/area, whatever

Mix(a, b, rate, filter)
-- with optional filter / rate (if rate is zero, disabled, if rate is anything
--  else, affects pressure dynamic (like, does it work against pressure?))
