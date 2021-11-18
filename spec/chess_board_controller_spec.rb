require './lib/board_controller.rb'

describe Board_Controller do

    it "Upon initializing creates creates instances of all the pieces" do
        board_control = Board_Controller.new
        types = {"P1" => Pawn,"P2" => Pawn,"P3" => Pawn,"P4" => Pawn,"P5" => Pawn,"P6" => Pawn,"P7" => Pawn,
                "P8" => Pawn,"R1" => Rook,"R2" => Rook,"X1" => Knight,"X2" => Knight,"B1" => Bishop,"B2" => Bishop,
                "Q" => Queen, "K" => King}
        types.each do |key,value|
            expect(board_control.pieces_black_exist?[key]).to be_kind_of(value)
            expect(board_control.pieces_white_exist?[key]).to be_kind_of(value)
        end
    end

    it "Upon initializing stores the piece at each relevant location" do
        board_control = Board_Controller.new
        types = {"P1" => Pawn,"P2" => Pawn,"P3" => Pawn,"P4" => Pawn,"P5" => Pawn,"P6" => Pawn,"P7" => Pawn,
            "P8" => Pawn,"R1" => Rook,"R2" => Rook,"X1" => Knight,"X2" => Knight,"B1" => Bishop,"B2" => Bishop,
            "Q" => Queen, "K" => King}
        types.each do |k,value|
            expect(board_control.store_check("Black").key(k)).to be_instance_of(Array)
            expect(board_control.store_check("White").key(k)).to be_instance_of(Array)
        end
    end
end