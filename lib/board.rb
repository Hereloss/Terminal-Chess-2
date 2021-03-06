# frozen_string_literal: true

require 'colorize'
require 'colorized_string'

class Board
  attr_reader :board

  def initialize
    @board = [[8, 'R'.red, 'N'.red, 'B'.red, 'Q'.red, 'K'.red, 'B'.red, 'N'.red, 'R'.red],
              [7, 'P'.red, 'P'.red, 'P'.red, 'P'.red, 'P'.red, 'P'.red, 'P'.red, 'P'.red],
              [6, 'O'.light_black, 'X'.light_black, 'O'.light_black, 'X'.light_black, 'O'.light_black, 'X'.light_black,
               'O'.light_black, 'X'.light_black],
              [5, 'X'.light_black, 'O'.light_black, 'X'.light_black, 'O'.light_black, 'X'.light_black, 'O'.light_black,
               'X'.light_black, 'O'.light_black],
              [4, 'O'.light_black, 'X'.light_black, 'O'.light_black, 'X'.light_black, 'O'.light_black, 'X'.light_black,
               'O'.light_black, 'X'.light_black],
              [3, 'X'.light_black, 'O'.light_black, 'X'.light_black, 'O'.light_black, 'X'.light_black, 'O'.light_black,
               'X'.light_black, 'O'.light_black],
              [2, 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
              [1, 'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'],
              [0, 'A'.green, 'B'.green, 'C'.green, 'D'.green, 'E'.green, 'F'.green, 'G'.green, 'H'.green]]
  end

  def whats_there(coords)
    coordinates = coords
    if (@board[coordinates[0]][coordinates[1]] == "\e[0;90;49mX\e[0m") || (@board[coordinates[0]][coordinates[1]] == "\e[0;90;49mO\e[0m")
      'E'
      # E is for empty here, to state no piece is there
    else
      @board[coordinates[0]][coordinates[1]]
    end
  end

  def converter(coords)
    @letters = %w[A B C D E F G H]
    location = [coords[1].to_i, @letters.find_index(coords[0]).to_i + 1]
    location[0] = 8 - location[0]
    location
  end

  def ray_empty?(from, to_loc, direction)
    current = converter(from)
    to = converter(to_loc)
    case direction
    when 'up'
      current[0] -= 1
      until current == to
        if whats_there(current) != 'E'
          puts 'Ray not clear'
          return false
        end
        current[0] -= 1
      end
      true
    when 'down'
      current[0] += 1
      until current == to
        if whats_there(current) != 'E'
          puts 'Ray not clear'
          return false
        end
        current[0] += 1
      end
      true
    when 'left'
      current[1] -= 1
      until current == to
        if whats_there(current) != 'E'
          puts 'Ray not clear'
          return false
        end
        current[1] -= 1
      end
      true
    when 'right'
      current[1] += 1
      until current == to
        if whats_there(current) != 'E'
          puts 'Ray not clear'
          return false
        end
        current[1] += 1
      end
      true
    when 'up_right'
      current[0] -= 1
      current[1] += 1
      until current == to
        if whats_there(current) != 'E'
          puts 'Ray not clear'
          return false
        end
        current[0] -= 1
        current[1] += 1
      end
      true
    when 'up_left'
      current[0] -= 1
      current[1] -= 1
      until current == to
        if whats_there(current) != 'E'
          puts 'Ray not clear'
          return false
        end
        current[0] -= 1
        current[1] -= 1
      end
      true
    when 'down_right'
      current[0] += 1
      current[1] += 1
      until current == to
        if whats_there(current) != 'E'
          puts 'Ray not clear'
          return false
        end
        current[0] += 1
        current[1] += 1
      end
      true
    when 'down_left'
      current[0] += 1
      current[1] -= 1
      until current == to
        if whats_there(current) != 'E'
          puts 'Ray not clear'
          return false
        end
        current[0] += 1
        current[1] -= 1
      end
      true
    end
  end

  def ray_trace(from, to, _for_check = false)
    direction = compass(from, to)
    ray_empty?(from, to, direction)
  end

  def compass(to, from)
    to_pos = converter(to)
    from_pos = converter(from)
    up = to_pos[0] > from_pos[0]
    down = to_pos[0] < from_pos[0]
    right = to_pos[1] < from_pos[1]
    left = to_pos[1] > from_pos[1]
    if up == true
      if left == true
        'up_left'
      elsif right == true
        'up_right'
      else
        'up'
      end
    elsif down == true
      if left == true
        'down_left'
      elsif right == true
        'down_right'
      else
        'down'
      end
    elsif right == true
      'right'
    elsif left == true
      'left'
    end
  end

  def update_board(from, to)
    move_from = converter(from)
    move_to = converter(to)
    piece_at_old_location = whats_there(move_from)
    @board[move_to[0]][move_to[1]] = piece_at_old_location
    parity = (move_from[0].to_i + move_from[1].to_i) % 2
    case parity
    when 0
      @board[move_from[0]][move_from[1]] = 'X'.light_black
    when 1
      @board[move_from[0]][move_from[1]] = 'O'.light_black
    end
  end

  def ray_return(from, to_loc, direction)
    @check_ray = []
    @check_ray << from
    current = converter(from)
    to = converter(to_loc)
    case direction
    when 'up'
      current[0] -= 1
      until current == to
        vert_location = 8 - current[0]
        @check_ray << [@letters[current[1] - 1], vert_location]
        current[0] -= 1
      end
      @check_ray
    when 'down'
      current[0] += 1
      until current == to
        vert_location = 8 - current[0]
        @check_ray << [@letters[current[1] - 1], vert_location]
        current[0] += 1
      end
      @check_ray
    when 'left'
      current[1] -= 1
      until current == to
        vert_location = 8 - current[0]
        @check_ray << [@letters[current[1] - 1], vert_location]
        current[1] -= 1
      end
      @check_ray
    when 'right'
      current[1] += 1
      until current == to
        vert_location = 8 - current[0]
        @check_ray << [@letters[current[1] - 1], vert_location]
        current[1] += 1
      end
      @check_ray
    when 'up_right'
      current[0] -= 1
      current[1] += 1
      until current == to
        vert_location = 8 - current[0]
        @check_ray << [@letters[current[1] - 1], vert_location]
        current[0] -= 1
        current[1] += 1
      end
      @check_ray
    when 'up_left'
      current[0] -= 1
      current[1] -= 1
      until current == to
        vert_location = 8 - current[0]
        @check_ray << [@letters[current[1] - 1], vert_location]
        current[0] -= 1
        current[1] -= 1
      end
      @check_ray
    when 'down_right'
      current[0] += 1
      current[1] += 1
      until current == to
        vert_location = 8 - current[0]
        @check_ray << [@letters[current[1] - 1], vert_location]
        current[0] += 1
        current[1] += 1
      end
      @check_ray
    when 'down_left'
      current[0] += 1
      current[1] -= 1
      until current == to
        vert_location = 8 - current[0]
        @check_ray << [@letters[current[1] - 1], vert_location]
        current[0] += 1
        current[1] -= 1
      end
      @check_ray
    end
  end
end
