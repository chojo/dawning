class LevelProxy

  def self.create name
    @levels ||= {}
    @uuid   ||= UUID.new
    unless @levels[name]
      id = @uuid.generate
      @levels[id] = new(id, name)
      @levels[id].launch
    else
      raise ArgumentError, "level with name [#{name}] already exists!"
    end
  end

  def self.levels
    @levels.try(:values) || []
  end

  def self.active
    levels.reject {|level| [:launched, :destroyed].include? level.state}
  end

  def self.find id
    if @levels
      @levels[id] or raise ArgumentError, "level with id #{id} not found!"
    end
  end

  def self.delete id
    @levels.delete id
  end

  # --- Instance Methods ----

  attr_reader :id, :name, :state, :players

  def initialize id, name
    @id         = id
    @name       = name
    @connection = Sim::Popen::ParentConnection.new
    @players    = {}
  end

  def method_missing method, *args, &block
    Rails.logger.debug "send action #{method} with #{args.first.inspect}"
    if args.first
      @connection.send_action method, args.first
    else
      @connection.send_action method
    end
  end

  # --- players ---

  def add_player user_id
    unless find_player(user_id)
      player_id = UUID.new.generate
      @connection.send_action :add_player, id: player_id
      @players[user_id] = player_id
    else
      raise ArgumentError, "user [#{user_id}] has already been added to this level [#{id}]"
    end
  end

  def remove_player user_id
    if player_id = find_player(user_id)
      @connection.send_action :remove_player, id: player_id
    end
  end

  def find_player user_id
    @players[user_id]
  end

  def action action, params
    @connection.send_action action, params
  end

  def player_action player_id, action, params
    @connection.send_player_action player_id, action, params
  end

  # --- states ---

  def launch
    sim_library = Rails.root.join('lib', 'sim', 'level.rb')
    level_class = 'Level'
    @connection.launch_subprocess(sim_library, level_class)
    @state = :launched
    self
  end

  def build config
    if @state == :launched
      config_file = Rails.root.join('config', 'levels', config).to_s
      @connection.send_action :build, config_file: config_file
      @state = :ready
    else
      raise ArgumentError, "level must be in state started but is in '#{@state}'"
    end
  end

  def start
    if @state == :ready
      @connection.send_action :start
      @state = :running
    else
      raise ArgumentError, "level must be in state built but is in '#{@state}'"
    end
  end

  def stop
    if @state == :running
      @connection.send_action :stop
      @state = :stopped
    else
      raise ArgumentError, "level must be in state running but is in '#{@state}'"
    end
  end

  def remove
    if @state == :stopped
      LevelProxy.delete @id
      @state = :destroyed
    else
      raise ArgumentError, "level must be in state stopped but is in '#{@state}'"
    end
  end

end
