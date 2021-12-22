require_relative './pieces/pieces.rb'
require_relative './board.rb'
require_relative './judge.rb'
require 'colorize'
require 'colorized_string'

class Board_Controller

    attr_reader :pieces_location_white
    attr_reader :pieces_white
    attr_reader :pieces_location_black
    attr_reader :pieces_black
    attr_reader :board
    attr_reader :piece_controller

    def initialize(piece_controller = Pieces.new,board = Board.new,judge = Judge.new(@board,piece_controller))
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
        return @piece_controller.pieces_black
    end

    def pieces_white_exist?
        return  @piece_controller.pieces_white
    end

    def store_check(colour)
        if colour == "White"
            return @piece_controller.pieces_location_white
        elsif colour == "Black"
            return @piece_controller.pieces_location_black
        end
    end

    def move_control_valid?(move_from, move_to,colour,in_check)
        case first_3_move_checks(move_from, move_to,colour)
        when true
            @piece_moving = @piece_controller.piece_id_from_location(move_from,colour)
            @taking = taking(move_to, colour)
            if @piece_controller.piece_type_from_location(move_from,colour)[0] == "X"
                ray = true
            else
                ray = ray_trace_control(move_from,move_to)
            end
            case (piece_check(move_to) && ray)
            when true
                    return piece_control(move_from,move_to,colour)
            when false
                return false
            end
        when false
            puts "First 3 failure"
            return false
        end
    end

    def first_3_move_checks(move_from, move_to,colour)
        case (move_on_board?(move_from) && move_on_board?(move_to) && piece_at_position(move_from,colour) && !(piece_at_position(move_to,colour)))
        when true
            return true
        when false
            return false
        end
    end

    def move_on_board?(move)
        @letters = ["A","B","C","D","E","F","G","H"]
        if (1..8).include?(move[1]) && @letters.include?(move[0])
            return true
        else
            puts "Move not on board faiure"
            return false
        end
    end

    def piece_at_position(position,colour)
        @piece_controller.piece_at_location(position,colour,"P")
    end

    def piece_at_position_no_colour(position)
        if piece = @piece_controller.piece_at_location(position,"Black","P")
            return [@piece_controller.piece_type_from_location(position,"Black")[0],"Black"]
        elsif piece = @piece_controller.piece_at_location(position,"White","P")
            return [@piece_controller.piece_type_from_location(position,"White")[0],"White"]
        else
            return ["None","N/A"]
        end

    end

    def taking(position,colour)
        @piece_controller.piece_at_location(position,colour,"T")
    end

    def piece_check(move_to)
        if @piece_moving.is_a?(Pawn)
            return @piece_moving.move(move_to,@taking)
        else
            return @piece_moving.move(move_to)
        end
    end

    def set_taking_for_test
        @taking = true
    end

    def set_a_pawn_for_test(bishop)
        @piece_moving = bishop
        @taking = false
    end

    def ray_trace_control(from,to)
        return board.ray_trace(from,to)
    end

    def return_board
        return @board.board
    end

    def piece_control(from,to,colour)
        @piece_moving.confirm(to)
        update_hash(from,to,colour)
        @board.update_board(from,to)
        if check_control(from,to,colour) == false
            puts "That puts you in check - you can't make that move!"
            return false
        else
            puts "I do hit here!"
            puts @taking
            if @taking == true
                remove_piece(to,colour)
            end
            return true
        end
    end

    def check_control(from,to,colour)
        if colour == "White"
            if check?(false, to, "Black") == true
                update_hash(to,from,colour)
                @piece_moving.confirm(from)
                @board.update_board(to,from)
                return false
            else
                return true
            end
        elsif colour == "Black"
            if check?(false, to, "White") == true
                update_hash(to,from,colour)
                @piece_moving.confirm(from)
                @board.update_board(to,from)
                return false
            else
                return true
            end
        end
    end

    def remove_piece(loc,colour)
        if colour == "White"
            piece_removing = @piece_controller.piece_id_from_location(loc,"Black")
            piece_removing.kill
            piece_removing.confirm([0,0])
            piece_number = @piece_controller.pieces_black.key(piece_removing)
            location = @piece_controller.pieces_location_black.key(piece_number)
            @piece_controller.pieces_location_black[location] = "None"
        elsif colour == "Black"
            piece_removing = @piece_controller.piece_id_from_location(loc,"White")
            piece_removing.kill
            piece_removing.confirm([0,0])
            piece_number = @piece_controller.pieces_white.key(piece_removing)
            location = @piece_controller.pieces_location_white.key(piece_number)
            @piece_controller.pieces_location_white[location] = "None"
        end
    end

    def update_hash(from,to,colour)
        if colour == "White"
            piece_number = @piece_controller.pieces_white.key(@piece_moving)
            @piece_controller.pieces_location_white[to] = piece_number
            @piece_controller.pieces_location_white[from] = nil
        elsif colour == "Black"
            piece_number = @piece_controller.pieces_black.key(@piece_moving)
            @piece_controller.pieces_location_black[to] = piece_number
            @piece_controller.pieces_location_black[from] = nil
        end
    end

    def player_makes_move(from,to,colour,in_check)
        valid = move_control_valid?(from,to,colour,in_check)
        return valid
    end

    def check?(in_check = false,move_to = nil,colour)
         @ray_trace_and_puts_in_check = false
        @piece_trying_to_escape = []
        pieces_putting_in_check = @judge.check?(colour)
            if pieces_putting_in_check.empty?
                return false
            else
                if colour == "White"
                    king_location = @piece_controller.location_king("Black")
                elsif colour == "Black"
                    king_location = @piece_controller.location_king("White")
                end
            pieces_putting_in_check.each do |object|
                if ray_trace_control(object.location,king_location)
                    @ray_trace_and_puts_in_check = true
                    @piece_trying_to_escape << object
                end
            end
            return @ray_trace_and_puts_in_check
        end
    end

    def checkmate?(colour)
        @locations_to_block = []
        @original_pieces_putting_king_in_check = @piece_trying_to_escape
        if king_moving_out_of_check(colour) == true
            puts "I think the king can escape!"
            return false
        else
            puts "King can't get out!"
            if @original_pieces_putting_king_in_check.length >= 2
                puts "Too many pieces putting you in check!"
                return true
            elsif @original_pieces_putting_king_in_check.length == 0
                puts "No pieces actually putting you in check!"
                return false
            else
                puts "We have just one piece putting you in check!"
                @checkmate = true
                location = (@original_pieces_putting_king_in_check[0]).location
                direction = @board.compass(location,@king_location)
                @locations_to_block = @board.ray_return(location,@king_location,direction)
                if (@original_pieces_putting_king_in_check[0]).is_a?(Knight)
                    puts 'The piece is a knight!'
                    @locations_to_block = [(@original_pieces_putting_king_in_check[0]).location]
                end
                if colour == "White"
                    @piece_controller.pieces_white.each do |key, object|
                        @locations_to_block.each do |location|
                            if move_control_valid?(object.location,location,"White",false) == true
                                puts "A piece can move there!"
                                @checkmate = false
                            end
                        end
                    end
                elsif colour == "Black"
                    @piece_controller.pieces_white.each do |key, object|
                        @locations_to_block.each do |location|
                            if move_control_valid?(object.location,location,"White",false) == true
                                puts "A piece can move there!"
                                @checkmate = false
                            end
                        end
                    end
                end
                return @checkmate
            end
        end
    end

    def set_pieces_to_escape(bishop = "Bishop")
        @piece_trying_to_escape << bishop
        puts @piece_trying_to_escape
    end

    def king_moving_out_of_check(colour)
        @king_location = @piece_controller.location_king(colour)
        @king_valid_moves = @piece_controller.king_valid_moves(@king_location)
        can_escape = false
        @king_valid_moves.each do |move|
            if move_control_valid?(@king_location, move,colour,false) == true
                can_escape = true
                update_hash(move,@king_location,colour)
                @piece_moving.confirm(@king_location)
                @board.update_board(move,@king_location)
            end
        end
        puts can_escape
        return can_escape
    end

    def queening
        ["A","B","C","D","E","F","G","H"].each do |letter|
            if (@piece_controller.pieces_location_white[[letter,8]].nil? == false && @piece_controller.pieces_location_white[[letter,8]] != "None")
                if @piece_controller.pieces_location_white[[letter,8]][0] == "P"
                    piece = @piece_controller.pieces_location_white([letter,8])
                    @piece_controller.pieces_location_white[[letter,8]] = "QP"
                    @piece_controller.pieces_white[piece] = Queen.new("White",[letter,8])
                    converted_queen_location = @board.converter([letter,8])
                    @board.board[converted_queen_location[0]][converted_queen_location[1]] = "Q"
                end
            elsif (!@piece_controller.pieces_location_black[[letter,1]].nil? && @piece_controller.pieces_location_black[[letter,1]] != "None")
                if @piece_controller.pieces_location_black[[letter,1]][0] == "P"
                    piece = @piece_controller.pieces_location_black([letter,1])
                    @piece_controller.pieces_location_black[[letter,1]] = "QP"
                    @piece_controller.pieces_black[piece] = Queen.new("White",[letter,1])
                    converted_queen_location = @board.converter([letter,1])
                    @board.board[converted_queen_location[0]][converted_queen_location[1]] = "Q"
                end
            end
        end
    end
end

