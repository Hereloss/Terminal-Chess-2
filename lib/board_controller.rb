require_relative './pieces/pawn.rb'
require_relative './pieces/rook.rb'
require_relative './pieces/queen.rb'
require_relative './pieces/bishop.rb'
require_relative './pieces/king.rb'
require_relative './pieces/knight.rb'


class Board_Controller

    def initialize
        store_pieces_location
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

    def pieces_black_exist?
        return @pieces_black
    end

    def pieces_white_exist?
        return @pieces_white
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

    def store_check(colour)
        if colour == "White"
            return @pieces_location_white
        elsif colour == "Black"
            return @pieces_location_black
        end
    end

    def move_control_valid?
    end

    def move_on_board?(move)
        @letters = ["A","B","C","D","E","F","G","H"]
        if (1..8).include?(move[0]) && @letters.include?(move[1])
            return true
        else
            return false
        end
    end
end

