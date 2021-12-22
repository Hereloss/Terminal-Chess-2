# frozen_string_literal: true

require 'colorize'
require 'colorized_string'

class Pawn
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

  def move(coords, taking)
    moves = { alive: @living, colour: @colour, valid: move_valid?(coords, @previously, taking) }
    move_valid?(coords, @previously, taking)
  end

  def confirm(coords)
    @current_location = coords
    @previously = true
  end

  def previous?
    @previously
  end

  def valid?(located, previous, taking)
    unless taking == true || located[0] == @current_location[0]
      puts 'Piece move not valid'
      return false
    end
    case @colour
    when 'White'
      white_valid(located, previous, taking)
    when 'Black'
      black_valid(located, previous, taking)
    end
  end

  def move_valid?(located, previous, taking)
    if @living == 'N'
      false
    else
      valid?(located, previous, taking)
    end
  end

  def white_valid(located, previous, taking)
    return white_takes(located) if taking == true

    if located[1].to_i == (@current_location[1].to_i + 1)
      true
    else
      return true if previous == false && (located[1].to_i == (@current_location[1].to_i + 2))

      puts 'Piece move not valid'
      false
    end
  end

  def black_valid(located, previous, taking)
    return black_takes(located) if taking == true

    if located[1].to_i == (@current_location[1].to_i - 1)
      true
    else
      return true if previous == false && (located[1].to_i == (@current_location[1].to_i - 2))

      puts 'Piece move not valid'
      false
    end
  end

  def white_takes(located)
    current_horz_loc = @letters.find_index(@current_location[0])
    letter = located[0]
    new_horz_loc = @letters.find_index(letter)
    if located[1].to_i == (@current_location[1].to_i + 1) && (current_horz_loc + 1 == new_horz_loc || current_horz_loc - 1 == new_horz_loc)
      true
    else
      false
    end
  end

  def black_takes(located)
    current_horz_loc = @letters.find_index(@current_location[0])
    letter = located[0]
    new_horz_loc = @letters.find_index(letter)
    if located[1].to_i == (@current_location[1].to_i - 1) && (current_horz_loc + 1 == new_horz_loc || current_horz_loc - 1 == new_horz_loc)
      true
    else
      false
    end
  end
end
