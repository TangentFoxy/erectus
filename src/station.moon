station = {
  player: { x: 0, y: 2 }
  {
    x: -2, y: -2
    "airlock"
    -- connections: { "atmosphere", "vacuum" }
  }
  {
    x: -1, y: -2
    "tank"
    connections: { "fabricator" }
  }
  {
    x: 0, y: -2
    "fabricator"
  }
  {
    x: 1, y: -2
    "tank"
  }
  {
    x: 2, y: -2
    "thruster"
  }
  {
    x: -1, y: 0
    "warp drive"
  }
  {
    x: 0, y: 0
    "battery"
  }
  {
    x: 1, y: 0
    "computer"
  }
  {
    x: -1, y: 1
    "tank", "H2", 12.5
  }
  {
    x: 0, y: 1
    "fuel cell", "H2O", 0.1
  }
  {
    x: 1, y: 1
    "tank", "O2", 12.5
  }
  {
    x: 2, y: 0
    "locker"
  }
  {
    x: 2, y: 1
    "bed"
  }
  {
    x: -2, y: 3
    "thruster"
  }
  {
    x: 0, y: 3
    "toilet"
  }
  {
    x: 1, y: 3
    "tank", "organic waste", 0.01
  }
  {
    x: 2, y: 3
    "water reclamation unit"
  }
  {
    x: -3, y: 0
    "tank", "H20", 0.1
  }
  {
    x: -3, y: 1
    "tank", "H20", 0.1
  }
  {
    x: 3, y: 0
    "tank", "N2", 12
  }
  {
    x: 3, y: 1
    "tank", "N2", 12
  }
  {
    x: 0, y: -5
    "solar panel"
  }
  {
    x: 0, y: -4
    "solar panel"
  }
  {
    x: 0, y: -3
    "solar panel"
  }
  {
    x: 0, y: 4
    "solar panel"
  }
  {
    x: 0, y: 5
    "solar panel"
  }
  {
    x: 0, y: 6
    "solar panel"
  }
  -- systems: {
  --   { "airlock", "atmosphere" }
  --   { "tank:H2", "fuel cell" }
  --   { "tank:O2", "fuel cell" }
  --   { "thruster", "tank:N2" }
  -- }
}




Fluid = require "Fluid"
fluids = require "fluids"

vaccum = Fluid(math.huge)
station = {
  atmosphere: Fluid() -- volume is corrected by Structure()
  systems: {
    -- "exterior hatch": Valve()
    "airlock": Fluid(10)\fill fluids.air -- TODO write it, needs to return self
    "oxygen tank": Fluid(8)\fill "O2", 12.5
    "hydrogen tank": Fluid(8)\fill "H2", 12.5
    "water tank": Fluid(12)\fill "H2O", 1/2
    "water tank 2": Fluid(12)\fill "H2O", 1/2
    "nitrogen tank": Fluid(12)\fill "N2", 10
    "nitrogen tank 2": Fluid(12)\fill "N2", 10
    "waste tank": Fluid(8)\fill "organic waste", 0.01
    "fuel cell": Fluid(5)\fill "H2O", 0.1
    -- "thruster": Thruster("nitrogen tank")
    Valve("nitrogen tank", "nitrogen tank 2")
  }
}






-- 12.5 atm pressure in oxy tanks

fluids = require "fluids"

station = {
  atmosphere: Fluid() -- volume to be reassigned later
}

vaccum_source = Fluid(math.huge)
n2_source = Fluid(12)\fill "N2", 12.5 -- TODO make fill function!

station[3] = {
  [0]: {
    img: "chemical-tank.png"
    systems: { n2_source }
  }
  [1]: ->
    tank = Fluid(12)\fill "N2", 12.5
    return {
      img: "chemical-tank.png"
      systems: { tank, Valve(tank, n2_source, 1, 1) }
    }
}

station[-2] = {
  [-2]: ->
    airlock = Fluid(10)\fill fluids.air -- TODO make fill function, make it return self
    exterior = Valve(airlock, vaccum_source, 7.5, 0)\set "name", "exterior hatch" -- TODO make set function
    interior = Valve(airlock, station.atmosphere, 8, 0)\set "name", "interior hatch"
    return {
      img: "airtight-hatch.png"
      systems: { airlock, exterior, interior }
    }
  [3]: ->
    thruster = Thruster()
    return {
      img: "abstract-072.png"
      systems: { thruster, Valve(n2_source, thruster, 1, 0)\set "name", "thruster" }
    }
}





Volume(8)\add "O2", 100



station = {}
for x = -2, 2
  station[x] = {}
  for y = -2, 3
    station[x][y] = {
      hull: true -- show floor
    }

airlock = station[-2][-2]
fab_tank = station[-1][-2]
fab = station[0][-2]
fab_tank2 = station[1][-2]
thruster = station[2][-2]

-- idea, create objects with x/y values, insert them later

airlock = {
  hatch: true
}

import insert from table
import Volume from require "fluids"

Tank = (t) ->
  if fucked
    nil

o2 = {internal}

internal = 8
external = 12
full = 100
half = 50

o2 = Tank internal, full

-- systems = {
--   O2: Volume(8)\add "O2", 100
--   H2: Volume(8)\add "H2", 100
--   N2: Volume(12)\add "N2", 150
--   -- N2_2: Volume(12)\add "N2", 150
--   H2O: Volume(12)\add "H2O", 50
--   -- H2O_2: Volume(12)\add "H2O", 50
-- }

systems = {}
insert Volume(8)\add "O2", 100
