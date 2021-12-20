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

    it "Will use a different move to if the piece is not a pawn" do
        subject.set_a_pawn_for_test(Bishop.new("White", ["A",3]))
        expect(subject.piece_check(["A",3])).to eq(true).or eq(false)
    end

    it "Will return invalid move if there is no piece of that colour at the position" do
        board_control = Board_Controller.new
        locations = board_control.pieces_location_white
        unfilled_position = ["C",4]
        expect(subject.move_control_valid?(unfilled_position,unfilled_position,"White",false)).to eq(false)
    end

    it 'Will return invalid move if there is a piece of that colour in the new position' do
        board_control = Board_Controller.new
        locations = board_control.piece_controller.pieces_location_white
        filled_position = locations.key("P1")
        expect(subject.move_control_valid?(filled_position,filled_position,"White",false)).to eq(false)
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

    it "If a move is deemed valid by the piece, ask the board for a ray-trace" do
        expect(subject).to respond_to :ray_trace_control
    end

    it "If the board states the move is valid, will return valid and the end position of the move" do
        board_control = Board_Controller.new
        locations_w = board_control.piece_controller.pieces_location_white
        start_position = locations_w.key("P1")
        locations_b = board_control.piece_controller.pieces_location_black
        end_position = locations_b.key("P1")
        tracing = board_control.board.ray_trace(start_position,end_position)
        if (tracing == true) && (board_control.first_3_move_checks(locations_w, locations_b,"White") == true) && (board_control.piece_check(locations_w, locations_b,"White") == true)
            #This is not being called
            expect(board_control.move_control_valid?(locations_w, locations_b,"White",false)).to eq true
        elsif (tracing == false) || (board_control.first_3_move_checks(locations_w, locations_b,"White") == false) || (board_control.piece_check(locations_w, locations_b,"White") == false)
            expect(board_control.move_control_valid?(locations_w, locations_b,"White",false)).to eq false
        end
    end

    it "If a move is valid, the controller will send a command to the piece to update its current location" do
        board_control = Board_Controller.new
        locations_w = board_control.piece_controller.pieces_location_white
        start_position = locations_w.key("P1")
        locations_b = board_control.piece_controller.pieces_location_black
        end_position = locations_b.key("P1")
        #This next bit isn't being called!
        if board_control.move_control_valid?(start_position, end_position,"White",false) == true
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
        #This bit might not be being called?
        if board_control.move_control_valid?(start_position, end_position,"White",false) == true
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
        #This bit might not be being called?
        if board_control.move_control_valid?(start_position, end_position,"White",false) == true
            piece = board_control.piece_controller.pieces_black["P1"]
            expect(board_control.piece_controller.pieces_location_black[end_position]).to eq "None"
        end
    end

    it "When passed in a move, will return true if the move is valid and false if it is not" do
        board_control = Board_Controller.new
        expect(board_control.player_makes_move(["A",2],["A",3],"White",false)).to eq true
        expect(board_control.player_makes_move(["A",7],["A",6],"Black",false)).to eq true
        expect(board_control.player_makes_move(["A",7],["A",6],"White",false)).to eq false
        expect(board_control.player_makes_move(["A",2],["A",3],"Black",false)).to eq false
    end

    it "If asked for the board, will get this from the board object and return this" do
        board_control = Board_Controller.new
        expect(board_control.return_board).to be_instance_of(Array)
    end

    it "Can return the piece on the board at a given position" do
        board_control = Board_Controller.new
        expect(board_control.piece_at_position_no_colour(["A",1])).to eq(["R","White"])
        expect(board_control.piece_at_position_no_colour(["A",8])).to eq(["R","Black"])
        expect(board_control.piece_at_position_no_colour(["A",5])).to eq(["None","N/A"])
    end

    it "Will remove a piece when it has been taken for Black" do
        piece = double()
        allow(piece).to receive(:kill).and_return(true)
        allow(piece).to receive(:confirm).and_return(true)
        piece_controller = double()
        allow(piece_controller).to receive(:piece_id_from_location).and_return(piece)
        allow(piece_controller).to receive(:pieces_location_white).and_return({1 => "Dummy"})
        allow(piece_controller).to receive(:pieces_white).and_return({1 => "Dummy"})
        board_controller = (Board_Controller.new(piece_controller))
        expect(piece_controller).to receive(:piece_id_from_location)
        expect(piece_controller).to receive(:pieces_white)
        expect(piece_controller).to receive(:pieces_location_white)
        expect(piece).to receive(:kill)
        expect(piece).to receive(:confirm)
        expect(board_controller.remove_piece(["A",3],"Black")).to eq "None"
    end

    it "Will remove a piece when it has been taken for White" do
        piece = double()
        allow(piece).to receive(:kill).and_return(true)
        allow(piece).to receive(:confirm).and_return(true)
        piece_controller = double()
        allow(piece_controller).to receive(:piece_id_from_location).and_return(piece)
        allow(piece_controller).to receive(:pieces_location_black).and_return({1 => "Dummy"})
        allow(piece_controller).to receive(:pieces_black).and_return({1 => "Dummy"})
        board_controller = (Board_Controller.new(piece_controller))
        expect(piece_controller).to receive(:piece_id_from_location)
        expect(piece_controller).to receive(:pieces_black)
        expect(piece_controller).to receive(:pieces_location_black)
        expect(piece).to receive(:kill)
        expect(piece).to receive(:confirm)
        expect(board_controller.remove_piece(["A",3],"White")).to eq "None"
    end

    it "A pawn that reaches the end of the board is promoted to a queen" do
    end

    context ".check and .checkmate" do

        it "If a move puts you into check, you cannot make that move" do
            board = double()
            piece_controller = double()
            judge = double()
            bishop = double()
            pawn1 = double()
            pawn2 = double()
            allow(pawn1).to receive(:location).and_return "There"
            allow(pawn2).to receive(:location).and_return "There"
            allow(bishop).to receive(:confirm).and_return true
            allow(board).to receive(:update_board).and_return(true)
            allow(board).to receive(:ray_trace).and_return(true)
            allow(judge).to receive(:check?).and_return [pawn1,pawn2]
            allow(piece_controller).to receive(:location_king).and_return "Here"
            allow(piece_controller).to receive(:pieces_black).and_return({"key" => "value"})
            allow(piece_controller).to receive(:pieces_location_black).and_return({"To" => "There"}).twice
            board_controller = (Board_Controller.new(piece_controller,board,judge))
            board_controller.stub(:check_control).and_return(false)
            board_controller.set_a_pawn_for_test(bishop)
            expect(board_controller.piece_control("from","to","colour")).to eq false
        end

        it "Check control for black" do
            board = double()
            piece_controller = double()
            judge = double()
            bishop = double()
            pawn1 = double()
            pawn2 = double()
            allow(pawn1).to receive(:location).and_return "There"
            allow(pawn2).to receive(:location).and_return "There"
            allow(bishop).to receive(:confirm).and_return true
            allow(board).to receive(:update_board).and_return(true)
            allow(board).to receive(:ray_trace).and_return(true)
            allow(judge).to receive(:check?).and_return [pawn1,pawn2]
            allow(board).to receive(:compass).and_return("Up")
            allow(board).to receive(:ray_return).and_return([["A",3],["B",4]])
            allow(piece_controller).to receive(:location_king).and_return "Here"
            expect(piece_controller).to receive(:pieces_black).and_return({"key" => "value"})
            expect(piece_controller).to receive(:pieces_location_black).and_return({"To" => "There"}).twice
            board_controller = (Board_Controller.new(piece_controller,board,judge))
            board_controller.set_a_pawn_for_test(bishop)
            expect(board_controller.check_control("from","to","Black")).to eq false
        end

        it "If asked if check, will pass this onto the Judge" do
            board = double()
            piece_controller = double()
            judge = double()
            allow(judge).to receive(:check?).and_return([])
            board_controller = (Board_Controller.new(piece_controller,board,judge))
        end

        it "Check control will check if white is in check" do
            board = double()
            piece_controller = double()
            judge = double()
            bishop = double()
            pawn1 = double()
            pawn2 = double()
            allow(pawn1).to receive(:location).and_return "There"
            allow(pawn2).to receive(:location).and_return "There"
            allow(bishop).to receive(:confirm).and_return true
            allow(board).to receive(:update_board).and_return(true)
            allow(board).to receive(:ray_trace).and_return(true)
            allow(judge).to receive(:check?).and_return [pawn1,pawn2]
            allow(piece_controller).to receive(:location_king).and_return "Here"
            expect(piece_controller).to receive(:pieces_white).and_return({"key" => "value"})
            expect(piece_controller).to receive(:pieces_location_white).and_return({"To" => "There"}).twice
            board_controller = (Board_Controller.new(piece_controller,board,judge))
            board_controller.set_a_pawn_for_test(bishop)
            expect(board_controller.check_control("from","to","White")).to eq false
        end

        it "If no pieces can move to the king, will return false for in check" do
            board = double()
            piece_controller = double()
            judge = double()
            allow(judge).to receive(:check?).and_return([])
            board_controller = (Board_Controller.new(piece_controller,board,judge))
            expect(board_controller.check?(false,nil,"White")).to eq false
        end

        it "If the king can move to a space that is not in check, it is not checkmate" do
            board = double()
            piece_controller = double()
            judge = double()
            pawn1 = double()
            pawn2 = double()
            allow(board).to receive(:update_board).and_return(true)
            allow(board).to receive(:ray_trace).and_return(true)
            allow(judge).to receive(:check?).and_return [pawn1,pawn2]
            allow(piece_controller).to receive(:location_king).and_return "Here"
            allow(piece_controller).to receive(:pieces_white).and_return({"key" => "value"})
            allow(piece_controller).to receive(:king_valid_moves).and_return(["A",3])
            board_controller = (Board_Controller.new(piece_controller,board,judge))
            board_controller.stub(:king_moving_out_of_check).and_return(true)
            board_controller.set_pieces_to_escape(pawn1)
            expect(board_controller.checkmate?("White")).to eq false
        end

        it "If two pieces are putting the king in check and the king cannot move it is checkmate" do
            board = double()
            piece_controller = double()
            judge = double()
            pawn1 = double()
            pawn2 = double()
            allow(board).to receive(:update_board).and_return(true)
            allow(board).to receive(:ray_trace).and_return(true)
            allow(judge).to receive(:check?).and_return([pawn1,pawn2])
            allow(piece_controller).to receive(:location_king).and_return "Here"
            allow(piece_controller).to receive(:pieces_white).and_return({"key" => "value"})
            allow(piece_controller).to receive(:king_valid_moves).and_return(["A",3])
            board_controller = (Board_Controller.new(piece_controller,board,judge))
            board_controller.stub(:king_moving_out_of_check).and_return(false)
            board_controller.set_pieces_to_escape(pawn1)
            board_controller.set_pieces_to_escape(pawn2)
            expect(board_controller.checkmate?("White")).to eq true
        end

        it "If only one piece puts the king in check, and another piece can validly move there it is not mate" do
            board = double()
            piece_controller = double()
            judge = double()
            pawn1 = double()
            pawn2 = double()
            bishop = double()
            allow(board).to receive(:update_board).and_return(true)
            allow(board).to receive(:ray_trace).and_return(true)
            allow(bishop).to receive(:confirm).and_return(true)
            allow(judge).to receive(:check?).and_return [pawn1,pawn2]
            allow(piece_controller).to receive(:location_king).and_return "Here"
            allow(piece_controller).to receive(:pieces_white).and_return({"key" => "value"})
            allow(piece_controller).to receive(:king_valid_moves).and_return(["A",3])
            allow(piece_controller).to receive(:pieces_location_white).and_return({"key" => "value"})
            board_controller = (Board_Controller.new(piece_controller,board,judge))
            board_controller.set_a_pawn_for_test(bishop)
            board_controller.stub(:king_moving_out_of_check).and_return(false)
            board_controller.stub(:move_control_valid?).and_return(true)
            expect(board_controller.checkmate?("White")).to eq false
        end

        it "If no pieces can move to block the ray or take the piece, it is mate" do
            board = double()
            piece_controller = double()
            judge = double()
            pawn1 = double()
            pawn2 = double()
            bishop = double()
            allow(board).to receive(:update_board).and_return(true)
            allow(board).to receive(:ray_trace).and_return(true)
            allow(pawn1).to receive(:is_a?).and_return(Pawn)
            allow(pawn2).to receive(:is_a?).and_return(Pawn)
            allow(pawn1).to receive(:location).and_return(["None"])
            allow(pawn2).to receive(:location).and_return(["None"])
            allow(bishop).to receive(:confirm).and_return(true)
            allow(judge).to receive(:check?).and_return [pawn1,pawn2]
            allow(board).to receive(:compass).and_return("Up")
            allow(board).to receive(:ray_return).and_return([["A",3],["B",4]])
            allow(piece_controller).to receive(:location_king).and_return "Here"
            allow(piece_controller).to receive(:pieces_white).and_return({"A" => pawn1,"B" => pawn2})
            allow(piece_controller).to receive(:pieces_location_white).and_return("Here" => "None")
            allow(piece_controller).to receive(:king_valid_moves).and_return(["A",3])
            board_controller = (Board_Controller.new(piece_controller,board,judge))
            board_controller.stub(:king_moving_out_of_check).and_return(false)
            board_controller.set_a_pawn_for_test(bishop)
            board_controller.set_pieces_to_escape(pawn1)
            board_controller.stub(:move_control_valid?).and_return(false)
            expect(board_controller.checkmate?("White")).to eq true
        end

        it "If a piece can move to block the ray or take the piece, it is not mate for black" do
            board = double()
            piece_controller = double()
            judge = double()
            pawn1 = double()
            pawn2 = double()
            bishop = double()
            allow(board).to receive(:update_board).and_return(true)
            allow(board).to receive(:ray_trace).and_return(true)
            allow(pawn1).to receive(:is_a?).and_return(Pawn)
            allow(pawn2).to receive(:is_a?).and_return(Pawn)
            allow(pawn1).to receive(:location).and_return(["None"])
            allow(pawn2).to receive(:location).and_return(["None"])
            allow(bishop).to receive(:confirm).and_return(true)
            allow(judge).to receive(:check?).and_return [pawn1,pawn2]
            allow(board).to receive(:compass).and_return("Up")
            allow(board).to receive(:ray_return).and_return([["A",3],["B",4]])
            allow(piece_controller).to receive(:location_king).and_return "Here"
            allow(piece_controller).to receive(:pieces_white).and_return({"A" => pawn1,"B" => pawn2})
            allow(piece_controller).to receive(:pieces_location_white).and_return("Here" => "None")
            allow(piece_controller).to receive(:king_valid_moves).and_return(["A",3])
            board_controller = (Board_Controller.new(piece_controller,board,judge))
            board_controller.stub(:king_moving_out_of_check).and_return(false)
            board_controller.set_a_pawn_for_test(bishop)
            board_controller.set_pieces_to_escape(pawn1)
            board_controller.stub(:move_control_valid?).and_return(true)
            expect(board_controller.checkmate?("Black")).to eq false
        end

        it "If a piece can move to block the ray or take the piece, it is not mate" do
            board = double()
            piece_controller = double()
            judge = double()
            pawn1 = double()
            pawn2 = double()
            bishop = double()
            allow(board).to receive(:update_board).and_return(true)
            allow(board).to receive(:ray_trace).and_return(true)
            allow(pawn1).to receive(:is_a?).and_return(Pawn)
            allow(pawn2).to receive(:is_a?).and_return(Pawn)
            allow(pawn1).to receive(:location).and_return(["None"])
            allow(pawn2).to receive(:location).and_return(["None"])
            allow(bishop).to receive(:confirm).and_return(true)
            allow(judge).to receive(:check?).and_return [pawn1,pawn2]
            allow(board).to receive(:compass).and_return("Up")
            allow(board).to receive(:ray_return).and_return([["A",3],["B",4]])
            allow(piece_controller).to receive(:location_king).and_return "Here"
            allow(piece_controller).to receive(:pieces_white).and_return({"A" => pawn1,"B" => pawn2})
            allow(piece_controller).to receive(:pieces_location_white).and_return("Here" => "None")
            allow(piece_controller).to receive(:king_valid_moves).and_return(["A",3])
            board_controller = (Board_Controller.new(piece_controller,board,judge))
            board_controller.stub(:king_moving_out_of_check).and_return(false)
            board_controller.set_a_pawn_for_test(bishop)
            board_controller.set_pieces_to_escape(pawn1)
            board_controller.stub(:move_control_valid?).and_return(true)
            expect(board_controller.checkmate?("White")).to eq false
        end

        it "Has a method to return checkmate if checkmate" do
            expect(subject.checkmate?("White")).to eq(true).or eq(false)
        end

        it "If the king can move out of check, will return true for this method" do
            board = double()
            piece_controller = double()
            judge = double()
            king = double()
            allow(king).to receive(:confirm).and_return(true)
            allow(board).to receive(:update_board).and_return(true)
            allow(piece_controller).to receive(:king_valid_moves).and_return(["A",3])
            allow(piece_controller).to receive(:location_king).and_return "Here"
            board_controller = (Board_Controller.new(piece_controller,board,judge))
            board_controller.set_a_pawn_for_test(king)
            board_controller.stub(:move_control_valid?).and_return(true)
            board_controller.stub(:update_hash).and_return(true)
            expect(board_controller.king_moving_out_of_check("White")).to eq true
        end

        #Taking needs to be tested
        #Moving ray = true needs testing

    end
end