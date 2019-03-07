import max, min from math

o2_consumption = 0.016
h2o_production = 9.2592592592593e-07
co2_production = 0.016
feces_production = 3.7651446759259e-07 -- want at 0.032, involuntary at 0.06
urine_production = 3.2407407407407e-06 -- want to urinate at 0.09, involuntary at 0.11

class Player
  new: (@structure, @x=0, @y=0) =>
    @state = {
      "oxygen starvation": 0
      "oxygen toxicity": 0
      "nitrogen narcosis": 0
      "helium narcosis": 0
      "carbon dioxide poisoning": 0
    }
    @feces = 0
    @urine = 0
    @actionTimer = 0
    if row = @structure[@x]
      if tile = row[@y]
        @atmosphere = tile.atmosphere

  update: (dt, input) =>
    if not @atmosphere
      @state["oxygen starvation"] += dt
    else
      pressure = @atmosphere\pressure!
      o2 = @atmosphere\percent "O2"
      if o2 < 0.195
        @state["oxygen starvation"] += dt
      else
        @state["oxygen starvation"] = max 0, @state["oxygen starvation"] - dt / 2
      @state["oxygen starvation"] += dt if pressure < 0.12
      @state["oxygen starvation"] += dt if pressure < 0.47 and o2 < -2.3 * pressure + 1.276
      if pressure > 2.5 or (pressure > 0.5 and o2 > -0.054 * pressure + 0.33)
        @state["oxygen toxicity"] += dt
        if o2 > 0.195
          @state["oxygen starvation"] = max 0, @state["oxygen starvation"] - dt * 3
      else
        @state["oxygen toxicity"] = max 0, @state["oxygen toxicity"] - dt * 2

      if pressure > 50
        n2 = @atmosphere\percent "N2"
        he = @atmosphere\percent "He"
        @state["nitrogen narcosis"] += dt if n2 > 0.5
        @state["helium narcosis"] += dt if pressure > 500 and he > 0.5 and n2 < 0.25
      else
        @state["nitrogen narcosis"] = max 0, @state["nitrogen narcosis"] - dt * 4
        @state["helium narcosis"] = max 0, @state["helium narcosis"] - dt * 8

      co2 = @atmosphere\percent "CO2"
      if co2 > 0.005
        @state["carbon dioxide poisoning"] += dt * (220 * co2 - 0.1)
      elseif co2 < 0.005
        @state["carbon dioxide poisoning"] = max 0, @state["carbon dioxide poisoning"] - dt

      -- using min garuntees we will not cause a negative oxygen
      -- it is assumed co2/h20 output will be stable until death when there is
      --  not enough oxygen
      @atmosphere\remove "O2", min o2, o2_consumption * dt
      @atmosphere\add "CO2", co2_production * dt
      @atmosphere\add "H2O", h2o_production * dt

    if @state["oxygen starvation"] >= 2.5 * 60 or
      @state["oxygen toxicity"] >= 60 * 60 or
      @state["carbon dioxide poisoning"] >= 60 * 60
        print "Dead."

    @actionTimer -= dt
    if @actionTimer <= 0
      x, y = input\get "move"
      if x != 0 or y != 0
        if x < 0
          x = -1
        elseif x > 0
          x = 1
        if y < 0
          y = -1
        elseif y > 0
          y = 1
        if @getTile! -- if inside
          if tile = @getTile x, y
            if tile.obj
              nil -- TODO access the object (or go through airlock)
            else
              @actionTimer = 1/6
              @x += x
              @y += y
              @atmosphere = tile.atmosphere -- assumes atmosphere might be different, but that only happens when passing through an airlock
        else -- outside
          if tile = @getTile x, y
            if tile.obj
              nil -- TODO access (or go through airlock)
            else
              nil -- TODO move

  getTile: (x=0, y=0) =>
    if row = @structure[@x + x]
      return row[@y + y]
