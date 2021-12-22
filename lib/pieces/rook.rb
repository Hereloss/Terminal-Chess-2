# frozen_string_literal: true

require 'colorize'
require 'colorized_string'

class Rook
  def initialize(colour, location)
    @living = 'Y'
    @colour = colour
    @current_location = location
    @previously = false
    @letters = %w[A B C D E F G H]
  end

  def alive
    @living
  end

  def kill
    @living = 'N'
    @living
  end

  attr_reader :colour

  def location
    @current_location
  end

  def move(coords)
    moves = { alive: @living, colour: @colour, valid: move_valid?(coords) }
    move_valid?(coords)
  end

  def confirm(coords)
    @current_location = coords
  end

  def valid?(located)
    current_horz_loc = @letters.find_index(@current_location[0])
    letter = located[0]
    new_horz_loc = @letters.find_index(letter)
    if (located[1].to_i == @current_location[1].to_i) || (current_horz_loc == new_horz_loc)
      true
    else
      puts 'Piece move not valid'
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
end
