class Filter
  new: (@high, @low, @allows={}, @volume=1) =>
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
      sum = (a - b) * @volume * dt
      for type in pairs @allows
        tmp = sum * @high\percent type
        @high\remove type, tmp
        @low\add type, tmp
