import graphics from love

width, height = graphics.getDimensions!
x_center, y_center = width / 2, height / 2
x_offset, y_offset = math.floor(width / 4), math.floor(height / 4)

images = require "images"
colors = require "colors"
Fluid = require "Fluid"
fluids = require "fluids"

class Structure
  new: (tiles_or_size=2) =>
    @systems = {}
    if "table" == type tiles_or_size
      for x, row in pairs tiles_or_size
        @[x] = {}
        for y, tile in pairs row
          @[x][y] = tile
          if tile.systems
            for system in *tile.systems
              table.insert @systems, tile.systems
    else
      volume = 10 * (2 * tiles_or_size + 1) ^ 2
      air = Fluid(volume)
      for type, percent in pairs fluids.air
        air\add type, volume * percent
      for x = -tiles_or_size, tiles_or_size
        @[x] = {}
        for y = -tiles_or_size, tiles_or_size
          @[x][y] = { img: "plain-square.png", color: colors.floor, atmosphere: air }

    -- temporary
    system = require("FilterPump")(@[0][0].atmosphere, Fluid(math.huge), { CO2: true }, 8, 1)
    @[0][1] = {
      img: "plain-square.png"
      obj: "abstract-045.png", color: colors.dark
      systems: { system }
      atmosphere: @[0][0].atmosphere
    }
    @systems[1] = system
    tank = Fluid(8)
    tank\add "O2", 100
    tanksys = require("Pump")(tank, @[0][0].atmosphere, 1, 0.0015)
    @[1][0] = {
      img: "plain-square.png"
      obj: "chemical-tank.png", color: colors.blue
      systems: { tanksys }
      atmosphere: @[0][0].atmosphere
    }
    @systems[2] = tanksys

  update: (dt) =>
    for system in *@systems
      system\update dt

  draw: (location) =>
    for x = location.x - x_offset, location.y + x_offset
      if row = @[x]
        for y = location.y - y_offset, location.y + y_offset
          if tile = row[y]
            graphics.setColor colors.floor
            graphics.draw images[tile.img], (x - location.x) * 32 + x_center, (y - location.y) * 32 + y_center, 0, 1/16, 1/16, 256, 256
            if tile.obj
              graphics.setColor tile.color or 1, 1, 1, 1
              graphics.draw images[tile.obj], (x - location.x) * 32 + x_center, (y - location.y) * 32 + y_center, 0, 1/16 * 0.9, 1/16 * 0.9, 256, 256
