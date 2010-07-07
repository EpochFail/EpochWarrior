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
  end

  def tick
	
    walk! :backward and return if under_attack? and low_health? 
    rest! and return if not fully_healed? and not under_attack? and feel.empty?
	rescue!  and return if feel.captive?
	pivot!  and return if feel.wall?
    attack!  and return if not feel.empty? and not feel.captive?
    walk!  and return
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

end

