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

    it "Can receive a move into it's move_control_valid method" do
        expect(subject).to respond_to :move_control_valid?
    end

    it "Will return invalid if the given move is outside of the board" do
        location1 = ["I",6]
        location2 = ["I",7]
        location3 = ["H",7]
        location4 = ["_",5]
        location5 = ["A",0]
        @letters = ["A","B","C","D","E","F","G","H"]
        new_location = [@letters.sample,rand(1..8)]
        expect(subject.move_on_board?(location1))
        expect(subject.move_on_board?(location2))
        expect(subject.move_on_board?(location3))
        expect(subject.move_on_board?(location4))
        expect(subject.move_on_board?(new_location))
    end

    it "Will return invalid move if there is no piece of that colour at the position" do
    end

    it 'Will return invalid move if there is a piece of that colour in the new position' do
    end

    it "Will pass the move to the piece to confirm if the move is valud for it" do
    end

    it "If a move is deemed valid by the piece, pass this to the board" do
    end

    it "If the board states the move is valid, will return valid and the end position of the move" do
    end
end