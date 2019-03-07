import min from math

class Valve
  new: (@high, @low, @volume=1, @rate=0) =>
  update: (dt) =>
    a, b = @high\pressure!, @low\pressure!
    if b > a
      tmp = @high
      @high = @low
      @low = tmp
      tmp = a
      a = b
      b = tmp
    elseif a > b
      @active = true
    else
      @active = false

    if @active
      sum = (a - b) * min(@rate, @volume) * dt
      for type in pairs @high.contents
        tmp = sum * @high\percent type
        @high\remove type, tmp
        @low\add type, tmp
