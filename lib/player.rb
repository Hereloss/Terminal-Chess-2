class Player
  def initialize(num)
    unless num == 2
      @colour = "White"
    else
      @colour = "Black"
    end
    @my_turn = false
  end

  def start_turn
    @my_turn = true
  end

end