class Test
  def self.and_return(sym, &block)
    define_method sym do |*args|
      block.call(*args)
      # end turn immediately after executing the block
      throw :end_turn
    end
  end
  
  def tick
    shoot 42
    puts "did it" # the goal is to get this not to print, since the previous call should force a return
  end
  
  def play_turn
    catch :end_turn do
      tick
    end
  end

  and_return :shoot do |x|
    puts "doing it with #{x}"
  end
end

Test.new.play_turn