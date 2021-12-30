# frozen_string_literal: true

require_relative './pieces/pieces'
require_relative './board'
require_relative './judge'
require 'colorize'
require 'colorized_string'

class Board_Controller
  attr_reader :pieces_location_white, :pieces_white, :pieces_location_black, :pieces_black, :board, :piece_controller

  def initialize(piece_controller = Pieces.new, board = Board.new, judge = Judge.new(@board, piece_controller))
    @piece_controller = piece_controller
    @board = board
    create_judge(judge)
    @piece_trying_to_escape = []
  end

  def create_judge(judge)
    piece_controller = @piece_controller
    @judge = judge
  end

  def pieces_black_exist?
    @piece_controller.pieces_black
  end

  def pieces_white_exist?
    @piece_controller.pieces_white
  end

  def store_check(colour)
    case colour
    when 'White'
      @piece_controller.pieces_location_white
    when 'Black'
      @piece_controller.pieces_location_black
    end
  end

  def move_control_valid?(move_from, move_to, colour, _in_check)
    case first_3_move_checks(move_from, move_to, colour)
    when true
      @piece_moving = @piece_controller.piece_id_from_location(move_from, colour)
      @taking = taking(move_to, colour)
      ray = if @piece_controller.piece_type_from_location(move_from, colour)[0] == 'X'
              true
            else
              ray_trace_control(move_from, move_to)
            end
      case (piece_check(move_to) && ray)
      when true
        piece_control(move_from, move_to, colour)
      when false
        false
      end
    when false
      puts 'First 3 failure'
      false
    end
  end

  def first_3_move_checks(move_from, move_to, colour)
    case (move_on_board?(move_from) && move_on_board?(move_to) && piece_at_position(move_from,
                                                                                    colour) && !piece_at_position(
                                                                                      move_to, colour
                                                                                    ))
    when true
      true
    when false
      false
    end
  end

  def move_on_board?(move)
    @letters = %w[A B C D E F G H]
    if (1..8).include?(move[1]) && @letters.include?(move[0])
      true
    else
      puts 'Move not on board faiure'
      false
    end
  end

  def piece_at_position(position, colour)
    @piece_controller.piece_at_location(position, colour, 'P')
  end

  def piece_at_position_no_colour(position)
    if piece = @piece_controller.piece_at_location(position, 'Black', 'P')
      [@piece_controller.piece_type_from_location(position, 'Black')[0], 'Black']
    elsif piece = @piece_controller.piece_at_location(position, 'White', 'P')
      [@piece_controller.piece_type_from_location(position, 'White')[0], 'White']
    else
      ['None', 'N/A']
    end
  end

  def taking(position, colour)
    @piece_controller.piece_at_location(position, colour, 'T')
  end

  def piece_check(move_to)
    if @piece_moving.is_a?(Pawn)
      @piece_moving.move(move_to, @taking)
    else
      @piece_moving.move(move_to)
    end
  end

  def set_taking_for_test
    @taking = true
  end

  def set_a_pawn_for_test(bishop)
    @piece_moving = bishop
    @taking = false
  end

  def ray_trace_control(from, to)
    board.ray_trace(from, to)
  end

  def return_board
    @board.board
  end

  def piece_control(from, to, colour)
    puts @piece_moving
    @piece_moving.confirm(to)
    update_hash(from, to, colour)
    @board.update_board(from, to)
    if check_control(from, to, colour) == false
      puts "That puts you in check - you can't make that move!"
      false
    else
      if @piece_moving.is_a?(King)
        case colour
        when 'White'
          if @piece_moving.castling == true
            @rook_location = []
            case to
            when ['C', 1]
              if @piece_controller.pieces_location_white[['A', 1]] == 'R1'
                rook = @piece_controller.pieces_white['R1']
                if (((@piece_controller.pieces_location_white[['B',
                  1]].nil? || @piece_controller.pieces_location_white[['B',
                                    1]]== (nil || "None")) && (@piece_controller.pieces_location_black[['B', 1]].nil? || @piece_controller.pieces_location_black[['B', 1]] == "None")) && rook.previously == false)            
                  rook.confirm(['D', 1])
                  @board.update_board(['A', 1], ['D', 1])
                else
                  return false
                end
              else
                return false
              end
            when ['G', 1]
              if @piece_controller.pieces_location_white[['H', 1]] == 'R2'
                  rook = @piece_controller.pieces_white['R2']
                if rook.previously == false
                  rook.confirm(['F', 1])
                  @board.update_board(['H', 1], ['F', 1])
                else
                  return false
                end
              else
                return false
              end
            else
                return false
            end
          end
        when 'Black'
          if @piece_moving.castling == true
            @rook_location = []
            case to
            when ['C', 8]
              if @piece_controller.pieces_location_black[['A', 8]] == 'R1'
                rook = @piece_controller.pieces_black['R1']
                if (((@piece_controller.pieces_location_white[['B',
                  8]].nil? || @piece_controller.pieces_location_white[['B',
                                    8]]== (nil || "None")) && (@piece_controller.pieces_location_black[['B', 8]].nil? || @piece_controller.pieces_location_black[['B', 8]] == "None")) && rook.previously == false)
                  rook.confirm(['D', 8])
                  @board.update_board(['A', 8], ['D', 8])
                else
                  return false
                end
              else
                return false
              end
            when ['G', 8]
              if @piece_controller.pieces_location_black[['H', 8]] == 'R2'
                rook = @piece_controller.pieces_black['R2']
                if rook.previously == false
                  rook.confirm(['F', 8])
                  @board.update_board(['H', 8], ['F', 8])
                else
                  return false
                end
              else
                return false
              end
            else
                return false
            end
          end
        end
      end
      remove_piece(to, colour) if @taking == true
      true
    end
  end

  def check_control(from, to, colour)
    case colour
    when 'White'
      if check?(false, to, 'Black') == true
        update_hash(to, from, colour)
        @piece_moving.confirm(from)
        @board.update_board(to, from)
        false
      else
        true
      end
    when 'Black'
      if check?(false, to, 'White') == true
        update_hash(to, from, colour)
        @piece_moving.confirm(from)
        @board.update_board(to, from)
        false
      else
        true
      end
    end
  end

  def remove_piece(loc, colour)
    case colour
    when 'White'
      piece_removing = @piece_controller.piece_id_from_location(loc, 'Black')
      piece_removing.kill
      piece_removing.confirm([0, 0])
      piece_number = @piece_controller.pieces_black.key(piece_removing)
      location = @piece_controller.pieces_location_black.key(piece_number)
      @piece_controller.pieces_location_black[location] = 'None'
    when 'Black'
      piece_removing = @piece_controller.piece_id_from_location(loc, 'White')
      piece_removing.kill
      piece_removing.confirm([0, 0])
      piece_number = @piece_controller.pieces_white.key(piece_removing)
      location = @piece_controller.pieces_location_white.key(piece_number)
      @piece_controller.pieces_location_white[location] = 'None'
    end
  end

  def update_hash(from, to, colour)
    case colour
    when 'White'
      piece_number = @piece_controller.pieces_white.key(@piece_moving)
      @piece_controller.pieces_location_white[to] = piece_number
      @piece_controller.pieces_location_white[from] = nil
    when 'Black'
      piece_number = @piece_controller.pieces_black.key(@piece_moving)
      @piece_controller.pieces_location_black[to] = piece_number
      @piece_controller.pieces_location_black[from] = nil
    end
  end

  def player_makes_move(from, to, colour, in_check)
    move_control_valid?(from, to, colour, in_check)
  end

  def check?(_in_check = false, _move_to = nil, colour)
    @ray_trace_and_puts_in_check = false
    @piece_trying_to_escape = []
    pieces_putting_in_check = @judge.check?(colour)
    if pieces_putting_in_check.empty?
      false
    else
      case colour
      when 'White'
        king_location = @piece_controller.location_king('Black')
      when 'Black'
        king_location = @piece_controller.location_king('White')
      end
      pieces_putting_in_check.each do |object|
        if ray_trace_control(object.location, king_location)
          @ray_trace_and_puts_in_check = true
          @piece_trying_to_escape << object
        end
      end
      @ray_trace_and_puts_in_check
    end
  end

  def checkmate?(colour)
    @locations_to_block = []
    @original_pieces_putting_king_in_check = @piece_trying_to_escape
    if king_moving_out_of_check(colour) == true
      puts 'I think the king can escape!'
      false
    else
      puts "King can't get out!"
      if @original_pieces_putting_king_in_check.length >= 2
        puts 'Too many pieces putting you in check!'
        true
      elsif @original_pieces_putting_king_in_check.length.zero?
        puts 'No pieces actually putting you in check!'
        false
      else
        puts 'We have just one piece putting you in check!'
        @checkmate = true
        location = (@original_pieces_putting_king_in_check[0]).location
        direction = @board.compass(location, @king_location)
        @locations_to_block = @board.ray_return(location, @king_location, direction)
        if (@original_pieces_putting_king_in_check[0]).is_a?(Knight)
          puts 'The piece is a knight!'
          @locations_to_block = [(@original_pieces_putting_king_in_check[0]).location]
        end
        case colour
        when 'White'
          @piece_controller.pieces_white.each do |_key, object|
            @locations_to_block.each do |location|
              if move_control_valid?(object.location, location, 'White', false) == true
                puts 'A piece can move there!'
                @checkmate = false
              end
            end
          end
        when 'Black'
          @piece_controller.pieces_white.each do |_key, object|
            @locations_to_block.each do |location|
              if move_control_valid?(object.location, location, 'White', false) == true
                puts 'A piece can move there!'
                @checkmate = false
              end
            end
          end
        end
        @checkmate
      end
    end
  end

  def set_pieces_to_escape(bishop = 'Bishop')
    @piece_trying_to_escape << bishop
    puts @piece_trying_to_escape
  end

  def king_moving_out_of_check(colour)
    @king_location = @piece_controller.location_king(colour)
    @king_valid_moves = @piece_controller.king_valid_moves(@king_location)
    can_escape = false
    @king_valid_moves.each do |move|
      next unless move_control_valid?(@king_location, move, colour, false) == true

      can_escape = true
      update_hash(move, @king_location, colour)
      @piece_moving.confirm(@king_location)
      @board.update_board(move, @king_location)
    end
    puts can_escape
    can_escape
  end

  def queening
    %w[A B C D E F G H].each do |letter|
      if @piece_controller.pieces_location_white[[letter,
                                                  8]].nil? == false && @piece_controller.pieces_location_white[[
                                                    letter, 8
                                                  ]] != 'None'
        if @piece_controller.pieces_location_white[[letter, 8]][0] == 'P'
          piece = @piece_controller.pieces_location_white([letter, 8])
          @piece_controller.pieces_location_white[[letter, 8]] = 'QP'
          @piece_controller.pieces_white[piece] = Queen.new('White', [letter, 8])
          converted_queen_location = @board.converter([letter, 8])
          @board.board[converted_queen_location[0]][converted_queen_location[1]] = 'Q'
        end
      elsif !@piece_controller.pieces_location_black[[letter,
                                                      1]].nil? && @piece_controller.pieces_location_black[[letter,
                                                                                                           1]] != 'None'
        if @piece_controller.pieces_location_black[[letter, 1]][0] == 'P'
          piece = @piece_controller.pieces_location_black([letter, 1])
          @piece_controller.pieces_location_black[[letter, 1]] = 'QP'
          @piece_controller.pieces_black[piece] = Queen.new('White', [letter, 1])
          converted_queen_location = @board.converter([letter, 1])
          @board.board[converted_queen_location[0]][converted_queen_location[1]] = 'Q'
        end
      end
    end
  end
end
