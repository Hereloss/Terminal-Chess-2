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
                piece_control(move_to)
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
        return board.ray_trace
    end

    def piece_control(to)
        @piece_moving.confirm(to)
    end


end

