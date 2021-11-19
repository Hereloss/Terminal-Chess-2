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
        expect(subject.compass(["A",3],["C",6])).to eq "up_right"
        expect(subject.compass(["C",6],["A",3])).to eq "down_left"
        expect(subject.compass(["A",6],["C",3])).to eq "down_right"
        expect(subject.compass(["C",3],["A",6])).to eq "up_left"
    end

    it "Can confirm the direction given in a move" do
    end

    it "Can trace the ray of this movement and return if it is clear or not" do
    end

    it "Can confirm if the King is in check using a ray-trace" do
    end

    it "Can confirm if this is checkmate with multiple ray-traces" do
    end
end        