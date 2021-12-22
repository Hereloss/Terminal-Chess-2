# frozen_string_literal: true

require_relative './board'
require 'colorize'
require 'colorized_string'
require_relative './pieces/pieces'

class Judge
  attr_reader :board, :piece_controller

  def initialize(board, piece_controller)
    @board = board
    @piece_controller = piece_controller
    @king_location = nil
    puts @piece_controller
  end

  def check?(colour)
    @piece_putting_in_check = []
    case colour
    when 'White'
      @king_location = @piece_controller.location_king('Black')
      check_valid_move_checking_black
    when 'Black'
      @king_location = @piece_controller.location_king('White')
      check_valid_move_checking_white
    end
  end

  private

  def check_valid_move_checking_white
    @piece_controller.pieces_black.each do |_piece, object|
      @piece_putting_in_check << object if puts_king_in_check?(@king_location, object)
    end
    @piece_putting_in_check
  end

  def check_valid_move_checking_black
    @piece_controller.pieces_white.each do |_piece, object|
      @piece_putting_in_check << object if puts_king_in_check?(@king_location, object) == true
    end
    @piece_putting_in_check
  end

  def puts_king_in_check?(move_to, piece)
    if piece.is_a?(Pawn)
      piece.move(move_to, true)
    else
      piece.move(move_to)
    end
  end

  def checkmate
    # Using the above, checks check for every possible move and if none are not check, returns true
  end
end
