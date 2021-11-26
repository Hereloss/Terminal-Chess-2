require_relative './board.rb'
require 'colorize'
require 'colorized_string'
require_relative './pieces/pieces.rb'

class Judge

  attr_reader :board,:piece_controller

  def initialize(board,piece_controller)
    @board = board
    @piece_controller = piece_controller
  end

  def piece_moving_in_check(move_to,colour)
    #Needs to update the board to use for check to a new version where the piece has already moved
  end

  #Section editing!
  def check?(colour)
    @piece_putting_in_check = []
    @king_location = @piece_controller.location_king(colour)
    if colour == "White"
      @king_location = @piece_controller.location_king("Black")
      return check_valid_move_checking_black
    elsif colour == "Black"
      @king_location = @piece_controller.location_king("White")
      return check_valid_move_checking_white
    end
  end

  def check_valid_move_checking_white
    @piece_controller.pieces_black.each do |piece,object|
      if puts_king_in_check?(@king_location,object)
        @piece_putting_in_check << object
      end
    end
    return @piece_putting_in_check
  end

  def check_valid_move_checking_black
    @piece_controller.pieces_white.each do |piece,object|
      if puts_king_in_check?(@king_location,object) == true
        @piece_putting_in_check << object
      end
    end
    return @piece_putting_in_check
  end

  def puts_king_in_check?(move_to,piece)
    if piece.is_a?(Pawn)
      return piece.move(move_to,true)
  else
      return piece.move(move_to)
  end
  end
  
  def checkmate
    #Using the above, checks check for every possible move and if none are not check, returns true
  end
  
end