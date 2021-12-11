require './lib/board.rb'

describe Board do

    it "Upon initializing, creates the board array object" do
        expect(subject.board).to be_instance_of(Array)
    end

    it "When given a co-ordinate, returns the object in the array at that point" do
        board = Board.new
        location = board.converter(["A",2])
        expect(board.whats_there(location)).to eq("P")
    end

    it "Can confirm if a given point in the array is empty" do
        board = Board.new
        location = board.converter(["A",5])
        expect(board.whats_there(location)).to eq("E")
    end

    it "Can confirm if a given set of points in the array are empty" do
        board = Board.new
        expect(board.ray_empty?(["A",3],["A",6],"up")).to eq true 
    end

    it "Has a function which will return a string referencing the direction" do
        expect(subject.compass(["A",3],["A",6])).to eq "up"
        expect(subject.compass(["A",6],["A",3])).to eq "down"
        expect(subject.compass(["A",3],["C",3])).to eq "right"
        expect(subject.compass(["C",3],["A",3])).to eq "left"
        expect(subject.compass(["A",3],["C",5])).to eq "up_right"
        expect(subject.compass(["C",5],["A",3])).to eq "down_left"
        expect(subject.compass(["A",5],["C",3])).to eq "down_right"
        expect(subject.compass(["C",3],["A",5])).to eq "up_left"
    end

    it "Can trace the ray of this movement and return if it is clear or not" do
        board = Board.new
        expect(board.ray_empty?(["A",3],["A",5],"up")).to eq true 
        expect(board.ray_empty?(["A",3],["C",3],"right")).to eq true 
        expect(board.ray_empty?(["C",3],["A",3],"left")).to eq true 
        expect(board.ray_empty?(["A",3],["C",5],"up_right")).to eq true 
        expect(board.ray_empty?(["A",5],["C",3],"down_right")).to eq true 
        expect(board.ray_empty?(["C",3],["A",5],"up_left")).to eq true 
        expect(board.ray_empty?(["C",5],["A",3],"down_left")).to eq true 
        expect(board.ray_empty?(["A",3],["A",8],"up")).to eq false 
        expect(board.ray_empty?(["A",6],["A",3],"down")).to eq true 
    end

    it "Can be passed just two locations, and will work out the direction and complete a ray trace" do
        board = Board.new
        expect(subject.ray_trace(["A",3],["A",5])).to eq true
        expect(subject.ray_trace(["A",5],["A",3])).to eq true
        expect(subject.ray_trace(["A",3],["C",3])).to eq true
        expect(subject.ray_trace(["C",3],["A",3])).to eq true
        expect(subject.ray_trace(["A",3],["C",5])).to eq true
        expect(subject.ray_trace(["C",5],["A",3])).to eq true
        expect(subject.ray_trace(["A",5],["C",3])).to eq true
        expect(subject.ray_trace(["C",3],["A",5])).to eq true
        expect(subject.ray_trace(["A",6],["A",8])).to eq false

    end

    it "When the move is confirmed, will update the board array with this new move" do
        board = Board.new
        board.update_board(["A",2],["A",3])
        expect(board.board[5][1]).to eq("P")
        expect(board.board[6][1]).to eq("\e[0;90;49mO\e[0m")
    end
    it "Can check for a left ray trace" do
        expect(subject.ray_empty?(["C", 2],["A",2],"left")).to eq false
    end

    it "Can check for a right ray trace" do
        expect(subject.ray_empty?(["A", 2],["C",2],"right")).to eq false
    end

    it "Can check for an up ray trace" do
        expect(subject.ray_empty?(["B", 1],["B",3],"up")).to eq false
    end

    it "Can check for a down ray trace" do
        expect(subject.ray_empty?(["B", 3],["B",1],"down")).to eq false
    end

    it "Can check for an up-left ray trace" do
        expect(subject.ray_empty?(["C", 1],["A",3],"up_left")).to eq false
    end

    it "Can check for an up-right ray trace" do
        expect(subject.ray_empty?(["A", 1],["C",3],"up_right")).to eq false
    end

    it "Can check for a down-left ray trace" do
        expect(subject.ray_empty?(["C", 3],["A",1],"down_left")).to eq false
    end

    it "Can check for a down-right ray trace" do
        expect(subject.ray_empty?(["A", 3],["C",1],"down_right")).to eq false
    end


    it "Can check and return the locations in a left ray including the start location" do
        expect(subject.ray_return(["C", 3],["A",3],"left")).to eq([["C", 3], ["B", 3]])
    end

    it "Can check and return the locations in a up ray including the start location" do
        expect(subject.ray_return(["A", 1],["A",3],"up")).to eq([["A", 1], ["A", 2]])
    end

    it "Can check and return the locations in a right ray including the start location" do
        expect(subject.ray_return(["A", 3],["C",3],"right")).to eq([["A", 3], ["B", 3]])
    end

    it "Can check and return the locations in a down ray including the start location" do
        expect(subject.ray_return(["A", 3],["A",1],"down")).to eq([["A", 3], ["A", 2]])
    end

    it "Can check and return the locations in a down right ray including the start location" do
        expect(subject.ray_return(["A", 3],["C",1],"down_right")).to eq([["A", 3], ["B", 2]])
    end

    it "Can check and return the locations in a down left ray including the start location" do
        expect(subject.ray_return(["C", 3],["A",1],"down_left")).to eq([["C", 3], ["B", 2]])
    end

    it "Can check and return the locations in a up right ray including the start location" do
        expect(subject.ray_return(["A", 1],["C",3],"up_right")).to eq([["A", 1], ["B", 2]])
    end

    it "Can check and return the locations in a up left ray including the start location" do
        expect(subject.ray_return(["C", 1],["A",3],"up_left")).to eq([["C", 1], ["B", 2]])
    end

end        