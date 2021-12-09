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
            puts @piece_controller.pieces_location_white
            puts @piece_controller.pieces_location_black
            return false
        else
            if @taking == true
                remove_piece(to,colour)
            end
            puts @piece_controller.pieces_location_white
            puts @piece_controller.pieces_location_black
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
        elsif colour = "Black"
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
        # if in_check == true
        #     return @judge.piece_moving_in_check(move_to,colour)
        # elsif in_check == false
            pieces_putting_in_check = @judge.check?(colour)
            if pieces_putting_in_check.empty?
                return false
            else
                if colour == "White"
                    king_location = @piece_controller.location_king("Black")
                elsif colour == "Black"
                    king_location = @piece_controller.location_king("White")
                end
                puts pieces_putting_in_check
                confirm = gets.chomp
                pieces_putting_in_check.each do |object|
                    return true if ray_trace_control(object.location,king_location)
                end
                return false
            end
        # end
    end

    def checkmate?
        return false
    end
end

