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
        location3 = ["H",9]
        location4 = ["_",5]
        location5 = ["A",0]
        @letters = ["A","B","C","D","E","F","G","H"]
        new_location = [@letters.sample,rand(1..8)]
        expect(subject.move_on_board?(location1)).to eq false
        expect(subject.move_on_board?(location2)).to eq false
        expect(subject.move_on_board?(location3)).to eq false
        expect(subject.move_on_board?(location4)).to eq false
        expect(subject.move_on_board?(new_location)).to eq true
    end

    it "Will return invalid move if there is no piece of that colour at the position" do
        board_control = Board_Controller.new
        locations = board_control.pieces_location_white
        unfilled_position = ["C",4]
        expect(subject.move_control_valid?(unfilled_position,unfilled_position,"White")).to eq(false)
    end

    it 'Will return invalid move if there is a piece of that colour in the new position' do
        board_control = Board_Controller.new
        locations = board_control.piece_controller.pieces_location_white
        filled_position = locations.key("P1")
        expect(subject.move_control_valid?(filled_position,filled_position,"White")).to eq(false)
    end

    it "Will return in one method if the above 3 tests are valid" do
        board_control = Board_Controller.new
        locations = board_control.piece_controller.pieces_location_white
        filled_position = locations.key("P1")
        unfilled_position = ["A",3]
        expect(subject.first_3_move_checks(filled_position,unfilled_position,"White")).to eq(true)

    end

    it "Will confirm if a piece is being taken with this move" do
        board_control = Board_Controller.new
        locations_w = board_control.piece_controller.pieces_location_white
        start_position = locations_w.key("P1")
        locations_b = board_control.piece_controller.pieces_location_black
        end_position = locations_b.key("P1")
        expect(board_control.taking(end_position,"White")).to eq true
    end

    it "Will pass the move to the piece to confirm if the move is valid for it" do
        expect(subject).to respond_to :piece_check
    end

    it "If the piece is valid, will receive this from the piece" do
        board_control = Board_Controller.new
        locations = board_control.piece_controller.pieces_location_white
        pawn = board_control.piece_controller.pieces_white["P1"]
        filled_position = locations.key("P1")
        @letters = ["A","B","C","D","E","F","G","H"]
        @letters.each do |let|
            (1..8).each do |num|
                unfilled_position = [let,num]
                if pawn.move(unfilled_position,false) == true
                    expect (board_control.piece_check).to eq true
                elsif pawn.move(unfilled_position,false) == false
                    expect (board_control.piece_check).to eq false
                end
            end
        end
    end

    it "If a move is deemed valid by the piece, ask the board for a ray-trace" do
        expect(subject).to respond_to :ray_trace_control
    end

    it "If the board states the move is valid, will return valid and the end position of the move" do
        board_control = Board_Controller.new
        locations_w = board_control.piece_controller.pieces_location_white
        start_position = locations_w.key("P1")
        locations_b = board_control.piece_controller.pieces_location_black
        end_position = locations_b.key("P1")
        tracing = board_control.board.ray_trace
        if (tracing == true) && (board_control.first_3_move_checks(locations_w, locations_b,"White") == true) && (board_control.piece_check(locations_w, locations_b,"White") == true)
            expect(board_control.move_control_valid?(locations_w, locations_b,"White")).to eq true
        elsif (tracing == false) || (board_control.first_3_move_checks(locations_w, locations_b,"White") == false) || (board_control.piece_check(locations_w, locations_b,"White") == false)
            expect(board_control.move_control_valid?(locations_w, locations_b,"White")).to eq false
        end
    end

    it "If a move is valid, the controller will send a command to the piece to update its current location" do
        board_control = Board_Controller.new
        locations_w = board_control.piece_controller.pieces_location_white
        start_position = locations_w.key("P1")
        locations_b = board_control.piece_controller.pieces_location_black
        end_position = locations_b.key("P1")
        if board_control.move_control_valid?(start_position, end_position,"White") == true
            piece = board_control.piece_controller.pieces_white["P1"]
            expect(piece.location).to eq(end_position)
        end
    end

    it "If a move is valid, the controller will update its position hash for the piece" do
        board_control = Board_Controller.new
        locations_w = board_control.piece_controller.pieces_location_white
        start_position = locations_w.key("P1")
        locations_b = board_control.piece_controller.pieces_location_black
        end_position = locations_b.key("P1")
        if board_control.move_control_valid?(start_position, end_position,"White") == true
            piece = board_control.piece_controller.pieces_white["P1"]
            expect(board_control.piece_controller.pieces_location_white[end_position]).to eq "P1"
        end
    end

    it "If a piece has been taken, it is removed from the hash" do
        board_control = Board_Controller.new
        locations_w = board_control.piece_controller.pieces_location_white
        start_position = locations_w.key("P1")
        locations_b = board_control.piece_controller.pieces_location_black
        end_position = locations_b.key("P1")
        if board_control.move_control_valid?(start_position, end_position,"White") == true
            piece = board_control.piece_controller.pieces_black["P1"]
            expect(board_control.piece_controller.pieces_location_black[end_position]).to eq "None"
        end
    end

    it "If asked for the board, will get this from the board object and return this" do
    end

    it "If asked if check, has a method to confirm this" do
    end
end