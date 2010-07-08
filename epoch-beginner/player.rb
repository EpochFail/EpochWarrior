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
	@shoot_direction = :forward
  end

  def tick
  
	shoot! @shoot_direction and return if should_shoot_range?
    walk! :backward and return if under_attack? and low_health?
    rest! and return if not fully_healed? and not under_attack? and feel.empty?	
	shoot! and return if should_shoot?
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
  
  def shoot_direction
	
  end
  
  

  
   def long_range_enemy?(direction)
        isSafe = -1	
		look(direction).each{|x| if isSafe == -1 and (x.character == "a" or x.character == "w") then isSafe = 1 
						elsif isSafe = -1 and x.enemy? then isSafe = 0 
						elsif isSafe = -1 and x.captive? then isSafe = 0 end}
		#print isSafe, "/",direction,"/"
		if isSafe == 1 then @shoot_direction =  direction	
			return true if isSafe == 1 end
			false
  end
  
  def should_shoot?
  look.reject(&:empty?).first.enemy? rescue false
  end

  def should_shoot_range?
    each_direction do |dir|
      return true if long_range_enemy?(dir)
    end
    false
  end
   def each_direction(&block)
    [:forward, :backward, :left, :right].each do |dir|
      yield(dir)
    end
  end

end

