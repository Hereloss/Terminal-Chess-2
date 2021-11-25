require_relative 'player'
require_relative 'board_controller'
require 'colorize'
require 'colorized_string'

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
    @who_is_in_check = "None"
    @current_color = "White"
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
      return "test_over"
    end
  end

  def play_game
    puts "New Game started - Player 1 is White, Player 2 is Black"
    puts "White goes first! Please press enter to begin:"
    colour = "White"
    game_playing(colour)
  end

  def game_playing(colour)
    case colour
    when "White"
      system "clear"
      @board_controller.board.board.each do |arr|
        p arr
      end
      turn_take("White")
      @current_colour = "Black"
      colour = "Black"
      game_playing(colour)
    when "Black"
      system "clear"
      @board_controller.board.board.each do |arr|
        p arr
      end
      turn_take("Black")
      @current_colour = "White"
      colour = "White"
      game_playing(colour)
    end
  end

  def turn_take(colour)
    if colour == "White"
      move = @player1.my_turn
    elsif colour == "Black"
      move = @player2.my_turn
    end
    valid = board_controller.player_makes_move(move[1],move[2],colour,@who_is_in_check)
    if valid == false
      puts "That move isn't valid - please put a valid move"
      turn_take(colour)
    elsif valid == true
      check(colour)
    end
    if colour == "White"
      @player1.end_turn
    elsif colour == "Black"
     @player2.end_turn
    end
  end

  def check(colour)
    in_check = board_controller.check?
    if in_check == true
      if board_controller.checkmate? 
        player_wins(colour)
      end
      @who_is_in_check = colour
    end
  end

  def player_wins(colour)
    puts "Player #{colour} wins!"
    puts "Thank you for playing - Goodbye!"
    exit
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