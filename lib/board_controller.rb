require_relative './pieces/pieces.rb'
require_relative './board.rb'

class Board_Controller

    attr_reader :pieces_location_white
    attr_reader :pieces_white
    attr_reader :pieces_location_black
    attr_reader :pieces_black
    attr_reader :board
    attr_reader :piece_controller

    def initialize
        @piece_controller = Pieces.new
        @board = Board.new
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

    def move_control_valid?(move_from, move_to,colour)
        case first_3_move_checks(move_from, move_to,colour)
        when true
            @piece_moving = @piece_controller.piece_id_from_location(move_from,colour)
            @taking = taking(move_to, colour)
            case (piece_check(move_to) && ray_trace_control(move_from,move_to))
            when true
                piece_control(move_to,colour)
                return true
            when false
                return false
            end
        when false
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

    def piece_control(to,colour)
        if @taking == true
            remove_piece(to,colour)
        end
        @piece_moving.confirm(to)
        update_hash(to,colour)
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

    def update_hash(to,colour)
        if colour == "White"
            piece_number = @piece_controller.pieces_white.key(@piece_moving)
            @piece_controller.pieces_location_white[to] = piece_number
        elsif colour == "Black"
            piece_number = @piece_controller.pieces_black.key(@piece_moving)
            @piece_controller.pieces_location_black[to] = piece_number
        end
    end

    def player_makes_move(from,to,colour)
        valid = move_control_valid?(from,to,colour)
        if valid == true
            @board.update_board(from,to)
        end
        outcome = [valid,colour,@board]
        return outcome
    end
end

