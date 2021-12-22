# frozen_string_literal: true

require 'colorize'
require 'colorized_string'

class King
  attr_reader :castling, :colour

  def initialize(colour, location)
    @living = 'Y'
    @colour = colour
    @current_location = location
    @previously = false
    @castling = false
    @letters = %w[A B C D E F G H]
  end

  def alive
    @living
  end

  def kill
    @living = 'N'
    @living
  end

  def location
    @current_location
  end

  def move(coords)
    moves = { alive: @living, colour: @colour, valid: move_valid?(coords) }
    move_valid?(coords)
  end

  def confirm(coords)
    @current_location = coords
    @previously = true
  end

  def valid?(located)
    current_horz_loc = @letters.find_index(@current_location[0])
    letter = located[0]
    new_horz_loc = @letters.find_index(letter)
    if ((located[1].to_i == @current_location[1].to_i + 1) || (located[1].to_i == @current_location[1].to_i - 1) || (located[1].to_i == @current_location[1].to_i)) &&
       (current_horz_loc == new_horz_loc || (current_horz_loc + 1 == new_horz_loc) || (current_horz_loc - 1 == new_horz_loc))
      true
    elsif @previously == false
      castling(located)
    else
      puts 'Piece move not valid'
      @castling = false
      false
    end
  end

  def castling(located)
    current_horz_loc = @letters.find_index(@current_location[0])
    letter = located[0]
    new_horz_loc = @letters.find_index(letter)
    if ((current_horz_loc + 2 == new_horz_loc) || (current_horz_loc - 2 == new_horz_loc)) && (located[1] == @current_location[1])
      @castling = true
      true
    else
      puts 'Piece move not valid'
      @castling = false
      false
    end
  end

  def move_valid?(located)
    if @living == 'N'
      false
    else
      valid?(located)
    end
  end

  def set_previously_for_test
    @previously = true
  end
end
