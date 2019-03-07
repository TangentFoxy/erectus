lurker = require "lurker"
lurker.quiet = true
debug = true

baton = require "baton"
input = baton.new {
  controls:
    left: { 'key:left', 'key:a', 'axis:leftx-', 'button:dpleft' }
    right: { 'key:right', 'key:d', 'axis:leftx+', 'button:dpright' }
    up: { 'key:up', 'key:w', 'axis:lefty-', 'button:dpup' }
    down: { 'key:down', 'key:s', 'axis:lefty+', 'button:dpdown' }
    -- action: { 'key:x', 'button:a' }
    exit: { 'key:escape' }
  pairs:
    move: { 'left', 'right', 'up', 'down' }
  joystick: love.joystick.getJoysticks![1]
}

images = require "images"
colors = require "colors"

-- floor = { img: "plain-square.png", color: colors.floor }

Structure = require "Structure"
structure = Structure(3)
Player = require "Player"
player = Player(structure)

love.update = (dt) ->
  -- dt *= 100
  require("lovebird").update!
  lurker.update!

  input\update!
  love.event.quit! if input\pressed "exit"

  player\update(dt, input)
  structure\update dt

  if debug
    if row = structure[player.x]
      if tile = row[player.y]
        atmosphere = tile.atmosphere
        if love.keyboard.isDown("c")
          atmosphere\add "CO2", 1
        if love.keyboard.isDown("n")
          atmosphere\add "N2", 10
        if love.keyboard.isDown("o")
          atmosphere\add "O2", 1
        if love.keyboard.isDown("h")
          atmosphere\add "He", 10

  -- structure[player.x] = {} unless structure[player.x]
  -- structure[player.x][player.y] = { img: "plain-square.png", color: colors.floor } unless structure[player.x][player.y]

width, height = love.graphics.getDimensions!
love.draw = ->
  if debug
    -- love.graphics.setColor 1, 1, 1, 1/4
    -- love.graphics.line width / 2, 0, width / 2 , height
    -- love.graphics.line 0, height / 2, width, height / 2
    love.graphics.setColor 1, 1/3, 1/3, 1
    love.graphics.line -player.x * 32 + width / 2, 0, -player.x * 32 + width / 2, height
    love.graphics.line 0, -player.y * 32 + height / 2, width, -player.y * 32 + height / 2

  structure\draw player

  love.graphics.setColor colors.player
  love.graphics.draw images["person.png"], width / 2, height / 2, 0, 1/16 * 0.9, 1/16 * 0.9, 256, 256

  if debug
    if row = structure[player.x]
      if tile = row[player.y]
        if atmosphere = tile.atmosphere
          love.graphics.setColor 1, 1, 1, 1
          love.graphics.print "Pressure: #{math.floor(10 * atmosphere\pressure!) / 10} atm (#{math.floor(10 * atmosphere.sum) / 10})", 0, 0
          i = 1
          for type, amount in pairs atmosphere.contents
            love.graphics.print "#{type}: #{math.floor(1000 * atmosphere\percent type) / 10}% (#{math.floor(100 * amount) / 100})", 0, i * 15
            i += 1

    i = 0
    love.graphics.setColor 1, 1, 1, 1
    for state, value in pairs player.state
      if value > 0
        love.graphics.print "Warning: #{state} (#{math.floor value})", width / 2, i * 15
        i += 1
