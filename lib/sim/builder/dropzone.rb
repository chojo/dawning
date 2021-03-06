module Builder
  class Dropzone

    attr_reader :world, :config

    def initialize world, config
      @world = world
      @config = config
    end

    def place_player player
      x = rand(2..(world.width-1-2))
      y = rand(config[:players][:from]..config[:players][:to])

      view = View.new(world, 0, 0, world.width, world.height)
      headquarter = create_headquarter(view, x,y)
      player.place(view, headquarter)
    end

    def create_headquarter view, x, y
      headquarter = Headquarter.build(x: x, y: y)
      world[x, y].merge!(pawn: headquarter)
      headquarter.create_pawns
      view.unfog(headquarter)
      headquarter.pawns.each do |pawn|
        view.unfog(pawn)
        world[pawn.x, pawn.y].merge!(pawn: pawn)
      end
      headquarter
    end

  end
end
