require 'colorize'
require 'colorized_string'

class Player

  attr_reader :is_my_turn, :colour
  def initialize(num)
    unless num == 2
      @colour = "White"
    else
      @colour = "Black"
    end
    @is_my_turn = false
  end

  def start_turn
    @is_my_turn = true
  end

  def end_turn
    @is_my_turn = false
  end

  def my_turn
    start_turn
    puts "Please enter a move in the format: Piece, Position From, Position To"
    puts "Please input moves in the format (A,3)"
    puts "This is #{@colour}s turn"
    puts "An example input would be: Bishop,(A,3),(A,5)"
    move = move_input
    if move.length != 5
      puts "That's not a valid move! Please type in the same format as above"
      my_turn
    else
      typed_well = check_typing(move)
      if typed_well == true
        return formatted(move)
      else
        my_turn
      end
    end
  end

  def move_input
    input = gets.chomp
    if input == "Surrender"
      puts "#{colour} surrenders! The other player wins by default!"
      exit
    end
    return input.split(",")
  end

  def check_typing(move)
    @letters = ["A","B","C","D","E","F","G","H"]
    @numbers = (1..8)
    unless ((@letters.include?(move[1][1])) && (@letters.include?(move[3][1])) && 
      (@numbers.include?(move[2][0].to_i)) && (@numbers.include?(move[4][0].to_i)))
      puts "That's not a valid move! Please type in the same format as above"
      return false
    else
    return true
    end
  end

  def formatted(move)
    return formatted_move = [move[0],[move[1][1],move[2][0].to_i],[move[3][1],move[4][0].to_i]]
  end
end