class AdminPlayer < Sim::Player

  attr_reader :world

  def create config
    self
  end

  def place view, headquarter
    @world = view.world
  end

  def init_map
    if @world
      { world: { width: @world.width, height: @world.height } }
    else
      false
    end
  end

  def view x, y, width, height
    w = Sim::Matrix.new(width, height)
    w.set_each_field_with_index do |i, j|
      @world[0 + x + i, 0 + y + j]
    end
    w
  end

end