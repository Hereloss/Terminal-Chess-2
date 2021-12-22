require_relative './pawn.rb'
require_relative './rook.rb'
require_relative './queen.rb'
require_relative './bishop.rb'
require_relative './king.rb'
require_relative './knight.rb'
require 'colorize'
require 'colorized_string'

class Pieces

    attr_reader :pieces_location_white
    attr_reader :pieces_white
    attr_reader :pieces_location_black
    attr_reader :pieces_black

    def initialize
        store_pieces_location
        assign_object_id
    end

    def store_pieces_location
        @pieces_location_white = {["A",2] => "P1",["B",2] => "P2",["C",2] => "P3",
                                ["D",2] => "P4",["E",2] => "P5",["F",2] => "P6",
                                ["G",2] => "P7", ["H",2] => "P8",
                                ["A",1] => "R1",["B",1] => "X1",["C",1] => "B1",
                                ["D",1] => "Q",["E",1] => "K",["F",1] => "B2",["G",1] => "X2",
                                ["H",1] => "R2" }
        @pieces_location_black = {["A",7] => "P1",["B",7] => "P2",["C",7] => "P3",
                                ["D",7] => "P4",["E",7] => "P5",["F",7] => "P6",
                                ["G",7] => "P7", ["H",7] => "P8",
                                ["A",8] => "R1",["B",8] => "X1",["C",8] => "B1",
                                ["D",8] => "Q",["E",8] => "K",["F",8] => "B2",["G",8] => "X2",
                                ["H",8] => "R2" }
    end

    def assign_object_id
        @pieces_black = {"P1" => Pawn.new("Black",@pieces_location_black.key("P1")), 
                "P2" => Pawn.new("Black",@pieces_location_black.key("P2")), 
                "P3" => Pawn.new("Black",@pieces_location_black.key("P3")), 
                "P4" => Pawn.new("Black",@pieces_location_black.key("P4")), 
                "P5" => Pawn.new("Black",@pieces_location_black.key("P5")), 
                "P6" => Pawn.new("Black",@pieces_location_black.key("P6")),
                "P7" => Pawn.new("Black",@pieces_location_black.key("P7")), 
                "P8" => Pawn.new("Black",@pieces_location_black.key("P8")), 
                "R1" => Rook.new("Black",@pieces_location_black.key("R1")),
                "R2" => Rook.new("Black",@pieces_location_black.key("R2")), 
                "X1" => Knight.new("Black",@pieces_location_black.key("X1")), 
                "X2" => Knight.new("Black",@pieces_location_black.key("X2")),
                "B1" => Bishop.new("Black",@pieces_location_black.key("B1")), 
                "B2" => Bishop.new("Black",@pieces_location_black.key("B2")), 
                "Q" => Queen.new("Black",@pieces_location_black.key("Q")),
                "K" => King.new("Black",@pieces_location_black.key("K"))}
        @pieces_white= {"P1" => Pawn.new("White",@pieces_location_white.key("P1")), 
                "P2" => Pawn.new("White",@pieces_location_white.key("P2")), 
                "P3" => Pawn.new("White",@pieces_location_white.key("P3")), 
                "P4" => Pawn.new("White",@pieces_location_white.key("P4")), 
                "P5" => Pawn.new("White",@pieces_location_white.key("P5")), 
                "P6" => Pawn.new("White",@pieces_location_white.key("P6")),
                "P7" => Pawn.new("White",@pieces_location_white.key("P7")), 
                "P8" => Pawn.new("White",@pieces_location_white.key("P8")), 
                "R1" => Rook.new("White",@pieces_location_white.key("R1")),
                "R2" => Rook.new("White",@pieces_location_white.key("R2")), 
                "X1" => Knight.new("White",@pieces_location_white.key("X1")), 
                "X2" => Knight.new("White",@pieces_location_white.key("X2")),
                "B1" => Bishop.new("White",@pieces_location_white.key("B1")), 
                "B2" => Bishop.new("White",@pieces_location_white.key("B2")), 
                "Q" => Queen.new("White",@pieces_location_white.key("Q")),
                "K" => King.new("White",@pieces_location_white.key("K"))}
    end

    def piece_type_from_location(loc,colour)
        if colour == "White"
            return @pieces_location_white[loc]
        elsif colour == "Black"
            return @pieces_location_black[loc]
        end
    end

    def piece_id_from_location(loc,colour)
        if colour == "White"
            piece = @pieces_location_white[loc]
            return piece_object = @pieces_white[piece]
        elsif colour == "Black"
            piece = @pieces_location_black[loc]
            return piece_object = @pieces_black[piece]
        end
    end

    def location_king(colour)
        if colour == "White"
            return @pieces_location_white.key("K")
        elsif colour == "Black"
            return @pieces_location_black.key("K")
        end
    end

    def king_valid_moves(location)
        p location
        @kings_valid_moves = []
        @letters = ["A","B","C","D","E","F","G","H"]
        @horz_location = @letters.index(location[0])
        if (location[1] != 8 && location[1] != 1)
            @allowed_vert_location = [location[1] - 1, location[1] + 1,location[1]]
        elsif location[1] == 8
            @allowed_vert_location = [7, 8]
        elsif location[1] == 1
            @allowed_vert_location = [2, 1]
        end
        if (@horz_location != 7 && @horz_location != 0)
            @allowed_horz_location = [@letters[@horz_location + 1], @letters[@horz_location -1],@letters[@horz_location]]
        elsif @horz_location == 7
            @allowed_horz_location = ["G", "H"]
        elsif @horz_location == 0
            @allowed_horz_location = ["B", "A"]
        end
        @allowed_vert_location.each do |vert|
            @allowed_horz_location.each do |horz|
                @kings_valid_moves << [horz,vert]
            end
        end
        return @kings_valid_moves
    end       


    def piece_at_location(position,colour,check_type)
        p position
        case check_type
        when "P"
            case colour
            when "White"
                if (@pieces_location_white[position].nil? || @pieces_location_black[position] == "None")
                    puts "No white piece at position"
                    return false
                else
                    puts "White Piece at position"
                    return true
                end
            when "Black"
                if (@pieces_location_black[position].nil? || @pieces_location_black[position] == "None")
                    puts "No black piece at position"
                    return false
                else
                    puts "Black Piece at position"
                    return true
                end
            end
        when "T"
            case colour
            when "Black"
                if @pieces_location_white[position].nil?
                    return false
                else
                    return true
                end
            when "White"
                if @pieces_location_black[position].nil?
                    return false
                else
                    return true
                end
            end
        end
    end
end
