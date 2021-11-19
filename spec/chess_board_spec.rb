require './lib/board.rb'

describe Board do

    it "Upon initializing, creates the board array object" do
        expect(subject.board).to be_instance_of(Array)
    end

    it "When given a co-ordinate, returns the object in the array at that point" do
        board = Board.new
        expect(board.whats_there(["A",2])).to eq("P")
    end

    it "Can confirm if a given point in the array is empty" do
        board = Board.new
        expect(board.whats_there(["A",5])).to eq("E")
    end

    it "Can confirm if a given set of points in the array are empty" do
    end

    it "Given the piece type, can confirm the ray the pieces movement will take" do
    end

    it "Can trace the ray of this movement and return if it is clear or not" do
    end

    it "Can confirm if the King is in check using a ray-trace" do
    end

    it "Can confirm if this is checkmate with multiple ray-traces" do
    end
end        