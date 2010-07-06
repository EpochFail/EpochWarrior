class Player
  def play_turn(warrior)
    @warrior = warrior
	if feel.empty? and health > 10
		walk!
	elsif feel.empty? and health < 10
		rest!
	elsif !feel.empty?
		attack!
	else
		walk!
	end
  end

  # Get rid of the warrior.everything
  def method_missing(sym, *args, &block)
    @warrior.send(sym, *args, &block)
  end
end
