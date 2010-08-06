class Test
  
  class << self
    attr_reader :actions
  end
  
  class << @actions = {}
    
    alias_method "old_[]", "[]"
    
    def [](sym, *params)
      send("old_[]", sym).call(*params)
    end
  end
  
  def self.and_return(sym, &block)
    @actions[sym] = Proc.new { |*params| block.call(*params); return }
  end
  
  def doit
    self.class.actions
  end
  
  def tick
    doit[:shoot, 42]
    puts "did it" # the goal is to get this not to print, since the previous call should force a return
  end
  
  def play_turn
    begin
      tick
    rescue LocalJumpError
      # ignore
    end
  end

  and_return :shoot do |x|
    puts "doing it with #{x}"
  end
end

Test.new.play_turn