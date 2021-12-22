require './lib/pieces/bishop.rb'

describe Bishop do

    it "Bishop returns if it is alive or dead" do
        bishop = Bishop.new("White",["A",5])
        expect(bishop.alive).to eq("Y").or eq("N")
    end

    it "A killed Bishop returns dead" do
        bishop = Bishop.new("White",["A",5])
        expect(bishop.kill).to eq("N")
    end

    it "Killing a Bishop changes living from alive to dead" do
        bishop = Bishop.new("White",["A",5])
        bishop.kill
        expect(bishop.alive).to eq("N")
    end

    it "Bishop can state it's colour" do
        bishop = Bishop.new("White",["A",5])
        expect(bishop.colour).to eq("White").or eq("Black")
    end

    it "A Bishops location is an array" do
        bishop = Bishop.new("White",["A",5])
        expect(bishop.location).to be_an_instance_of(Array)
    end

    it "A Bishop knows it's horizontal co-ordinates" do
        expect(Bishop.new("White",["A",5]).location[0]).to satisfy { |value| ["A", "B","C","D","F","G","H"].include?(value) }
    end

    it "A Bishop knows it's vertical co-ordinates" do
        expect(Bishop.new("White",["A",5]).location).to include (a_kind_of(Integer))
    end

    it "A Bishop knows it's exact vertical co-ordinates" do
        expect(Bishop.new("White",["A",5]).location[1]).to satisfy { |value| (1..8).include?(value) }
    end


    it "A Bishop knows if a given move to it is valid" do
        bishop = Bishop.new("White",["A",5])
        @located = bishop.location
        expect(bishop.valid?(@located)).to eq(true).or eq(false)
    end

    it "A Bishop when given a move will confirm if the move is valid" do
        coords = []
        expect(Bishop.new("White",["A",5]).move(coords)).to eq(true).or eq(false)
    end


    it "A move is valid if it is if it is in a diagonal line of the piece " do
        piece = Bishop.new("White",["C",5])
        @letters = ["A","B","C","D","E","F","G","H"]
        new_location = ["E", 7]
        new_horz_loc = @letters.find_index(new_location[0])
        old_horz_loc = @letters.find_index("C")
        diff_vert = new_location[1] - 5
        diff_horz = new_horz_loc - old_horz_loc
        if diff_horz.abs - diff_vert.abs == 0
            expect(piece.valid?(new_location)).to eq(true)
        end
    end
    

    it "Bishop receives it's start location and colour upon initalising from board" do
        expect(Bishop.new("White",["A",5]).location).to_not be_empty
        expect(Bishop.new("White",["A",5]).colour).to_not be_empty
    end

    it "If a Bishop is dead, the move is automatically invalid" do
        bishop = Bishop.new("White",["A",5])
        @located = bishop.location
        bishop.kill
        expect(bishop.move_valid?([@located[0],@located[1] + 1])).to eq(false)
    end

    it "Bishop applies the new position and confirms the validity" do
        bishop = Bishop.new("White",["C",5])
        @located = bishop.location
        expect(bishop.move(["B",6])).to eq true
        expect(bishop.move(["D",4])).to eq true
    end

    it "Once a move is confirmed, a Bishop updates it's current position" do
        bishop = Bishop.new("White",["A",5])
        @located = ["A",5]
        @new_position = bishop.confirm(["A",6])
        expect(@located).to_not eq(@new_position)
    end
end