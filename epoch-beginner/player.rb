class Player
  def play_turn(warrior)
    @warrior = warrior
    walk!
  end

  # Get rid of the warrior.everything
  def method_missing(sym, *args, &block)
    @warrior.send(sym, *args, &block)
  end
end
