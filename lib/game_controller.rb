require_relative 'player'
require_relative 'board_controller'

class Game_Controller

  attr_reader :player1, :player2, :board_controller, :choice

  def initialize
    @board_controller = Board_Controller.new
    @player1 = Player.new(1)
    @player2 = Player.new(2)
    @players = [@player1,@player2]
    puts "Welcome To Chess!"
    puts "What would you like to do?"
    @rule_read = 0
    menu
  end

  def choice_input
    choice = gets.chomp.to_i
    if !(1..3).include?(choice)
      puts "That's not an option!"
      choice_input
    end
    return choice
  end

  def menu
    puts "1. Play a game"
    puts "2. View the rules"
    puts "3. Quit"
    @choice = choice_input
    menu_option_chosen
  end

  def menu_option_chosen
    case @choice
    when 1
      play_game
    when 2
      rules
    when 3
      exit
    when 4
      #Test option
      return "test_over"
    end
  end

  def play_game
    puts "New Game started - Player 1 is White, Player 2 is Black"
    puts "White goes first!"
    @current_color = "White"
    case colour
    when "White"
    when "Black"
    return "#{@current_colour} wins!"
  end

  def rules
    puts "Chess is a 2 player game"
    puts "One player is White, the other is Black. White moves first"
    puts "Your goal is to checkmate the King - make it so it cannot escape Check"
    puts "A king is in check when it would be taken the next turn by a piece"
    puts "The pieces move as follows: Rook, straight line, Bishop, Diagonal lines, Queen, Straight line and Diagonal Lines"
    puts "Knight, An L shape (1 one way, 2 the other) in any direction, King, 1 square in any direction"
    puts "Pawn, 1 square forward unless it is it's first move, when it can move 2 squares"
    puts "Once you've finished reading these, please just press enter"
    confirms = confirm
    system "clear"
    play_game
  end

  def confirm
    @confirm = gets.chomp
  end
end