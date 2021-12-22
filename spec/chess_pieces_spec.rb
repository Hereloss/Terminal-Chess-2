require './lib/pieces/pieces.rb'

describe Pieces do

    it "Can check if there is a piece at a given position" do
        pieces = Pieces.new
        locations = pieces.pieces_location_white
        filled_position = locations.key("P1")
        expect(pieces.piece_at_location(filled_position,"White","P")).to eq(true)
    end

    it "Can check if there is a piece at a given position" do
        pieces = Pieces.new
        locations = pieces.pieces_location_black
        filled_position = locations.key("P1")
        expect(pieces.piece_at_location(filled_position,"White","T")).to eq(true)
    end


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

    it "Can return an object when asked what piece is in a location" do
        pieces = Pieces.new
        locations = pieces.pieces_location_white
        filled_position = locations.key("P1")
        expect(pieces.piece_id_from_location(filled_position,"White")).to be_kind_of(Pawn)
    end

    it "Can check if there is a piece to be taken in a given position" do
        pieces = Pieces.new
        locations = pieces.pieces_location_white
        filled_position = locations.key("P1")
        expect(pieces.piece_at_location(filled_position,"Black","T")).to eq(true)
    end

    it "Can check if there is a piece to be moved in a given position" do
        pieces = Pieces.new
        locations = pieces.pieces_location_white
        filled_position = locations.key("P1")
        expect(pieces.piece_at_location(filled_position,"White","P")).to eq(true)
    end


    it "Can check the king's valid move where it is in the middle of the board" do
        pieces = Pieces.new
        expect(pieces.king_valid_moves(["C",3])).to eq([["D", 2], ["B", 2], ["C", 2], ["D", 4], ["B", 4], ["C", 4], ["D", 3], ["B", 3], ["C", 3]])
    end

    it "Can check the king's vlaid moves where it is on the edge of the board" do
        pieces = Pieces.new
        expect(pieces.king_valid_moves(["A",3])).to eq([["B", 2], ["A", 2], ["B", 4], ["A", 4], ["B", 3], ["A", 3]])
        expect(pieces.king_valid_moves(["C",1])).to eq([["D", 2], ["B", 2], ["C", 2], ["D", 1], ["B", 1], ["C", 1]])
        expect(pieces.king_valid_moves(["C",8])).to eq([["D", 7], ["B", 7], ["C", 7], ["D", 8], ["B", 8], ["C", 8]])
        expect(pieces.king_valid_moves(["H",4])).to eq([["G", 3], ["H", 3], ["G", 5], ["H", 5], ["G", 4], ["H", 4]])
    
    end

    it "Can check the king's valid moves where it is in a corner" do
        pieces = Pieces.new
        expect(pieces.king_valid_moves(["A",1])).to eq([["B", 2], ["A", 2], ["B", 1], ["A", 1]])
    end
end
