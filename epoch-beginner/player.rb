class Player

  def play_turn(warrior)
    @warrior = warrior
    tick
    @state[:last_health] = health
  end

  # Get rid of the warrior.everything
  def method_missing(sym, *args, &block)
    @warrior.send(sym, *args, &block)
  end

  def initialize
    @state = {
      :last_health => 20
    }
    @config = {
      :minimum_health => 9,
      :maximum_health => 20
    }
	@direction = :backward
  end

  def tick
	
    walk! backwards and return if under_attack? and low_health? 
    rest! and return if not fully_healed? and not under_attack? and feel(@direction).empty?
	rescue! @direction and return if feel(@direction).captive?
	walk! reverse_direction and return if feel(@direction).wall?
    attack! @direction and return if not feel(@direction).empty? and not feel(@direction).captive?
    walk! @direction and return
  end

  def under_attack?
    health < @state[:last_health]
  end

  def low_health?
    health <= @config[:minimum_health]
  end

  def fully_healed?
    health >= @config[:maximum_health]
  end
  def reverse_direction
    @direction = (@direction == :forward) ? :backward : :forward
  end
  def backwards
	(@direction == :forward) ? :backward : :forward
  end

end

