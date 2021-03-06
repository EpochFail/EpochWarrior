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
      :last_health => 20,
      :targets => []
    }
    @config = {
      :minimum_health => 9,
      :maximum_health => 20
    }
    @directions = [:forward, :backward]
    @target_prioritization = ['C','w', 'a', 'S', 's']
    @enemy_range = {'w'=>2,'a'=>2,'S'=>0,'s'=>0}
  end

  def tick
    assess_the_situation
    
    shoot! direction_to_target and return if enemy_in_range? and should_shoot? direction_to_target
    retreat! and return if under_attack? and low_health?
    rest! and return if not fully_healed? and not under_attack? and feel.empty? and not nothing_but_stairs?
    rescue! direction_to_target and return if feel.captive?
    pivot! and return if nothing_but_wall? or direction_to_target == :backward
    attack! and return if not feel.empty? and not feel.captive?
    walk! direction_to_target and return
  end
  
  def retreat!
    walk! :backward
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
  
  def assess_the_situation
    @state[:targets] = @directions.map { |d| look(d).reject { |s| s.empty? or s.wall?}
                         .map { |t| {:direction => d, :space => t} } }
                         .flatten
  end
  
  def enemy_in_range?
    not @state[:targets].select {|t| t[:space].enemy?}.empty?
  end
  
  def enemy_can_attack?
    spaces = look(direction_to_target)
    spaces.map! do |s|
      s.enemy? ? @enemy_range[s.character] : -1
    end
    spaces.select {|s| s >= spaces.index(s)}.size > 0
  end
  
  def direction_to_target
    target = @state[:targets].sort { |a,b| @target_prioritization.index(a[:space].character) <=> @target_prioritization.index(b[:space].character) }.first     
    target[:direction] rescue :forward
  end
  
  def nothing_but_wall?
    return false if look.select(&:stairs?).size == 1
    return false if look.reject(&:empty?).size == 0
    return true if look.reject(&:empty?).reject(&:wall?).size == 0
    return false
  end
  
  def nothing_but_stairs?
    look.select(&:stairs?).size == 1 and look.reject(&:empty?).reject(&:wall?).size == 0
  end
  
  def should_shoot?(direction)
    look(direction).reject(&:empty?).first.enemy? rescue false
  end
end
