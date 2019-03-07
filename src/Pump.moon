import abs, min from math

class Pump
  new: (@source, @destination, @volume=1, @rate=0) =>
  reverse: =>
    tmp = @source
    @source = @destination
    @destination = tmp
  update: (dt) =>
    if @rate > 0
      sum = abs(@source\pressure! - @destination\pressure!) * @rate * @volume * dt
      for type, amount in pairs @source.contents
        tmp = sum * @source\percent type
        @source\remove type, tmp
        @destination\add type, tmp
