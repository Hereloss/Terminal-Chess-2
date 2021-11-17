require './lib/pieces/king.rb'

describe King do

    it "King returns if it is alive or dead" do
        king = King.new("White",["A",5])
        expect(king.alive).to eq("Y").or eq("N")
    end

    it "A killed King returns dead" do
        king = King.new("White",["A",5])
        expect(king.kill).to eq("N")
    end

    it "Killing a King changes living from alive to dead" do
        king = King.new("White",["A",5])
        king.kill
        expect(king.alive).to eq("N")
    end

    it "King can state it's colour" do
        king = King.new("White",["A",5])
        expect(king.colour).to eq("White").or eq("Black")
    end

    it "A Kings location is an array" do
        king = King.new("White",["A",5])
        expect(king.location).to be_an_instance_of(Array)
    end

    it "A King knows it's horizontal co-ordinates" do
        expect(King.new("White",["A",5]).location[0]).to satisfy { |value| ["A", "B","C","D","F","G","H"].include?(value) }
    end

    it "A King knows it's vertical co-ordinates" do
        expect(King.new("White",["A",5]).location).to include (a_kind_of(Integer))
    end

    it "A King knows it's exact vertical co-ordinates" do
        expect(King.new("White",["A",5]).location[1]).to satisfy { |value| (1..8).include?(value) }
    end


    it "A King knows if a given move to it is valid" do
        king = King.new("White",["A",5])
        @located = king.location
        expect(king.valid?(@located)).to eq(true).or eq(false)
    end

    it "A King when given a move will confirm if the move is valid" do
        coords = []
        expect(King.new("White",["A",5]).move(coords)[:valid]).to eq(true).or eq(false)
    end

    it "A King when given a move will confirm its colour" do
        coords = []
        expect(King.new("White",["A",5]).move(coords)[:colour]).to eq("White").or eq("Black")
    end


    it "A move is valid if it is within 1 space around of the piece's current postition " do
        piece = King.new("White",["A",5])
        @located = piece.location
        expect(piece.valid?([@located[0],@located[1] - 1])).to eq(true)
    end
    

    it "King receives it's start location and colour upon initalising from board" do
        expect(King.new("White",["A",5]).location).to_not be_empty
        expect(King.new("White",["A",5]).colour).to_not be_empty
    end

    it "If a King is dead, the move is automatically invalid" do
        king = King.new("White",["A",5])
        @located = king.location
        king.kill
        expect(king.move_valid?([@located[0],@located[1] + 1])).to eq(false)
    end

    it "King applies the new position and confirms the validity" do
        king = King.new("White",["A",5])
        @located = king.location
        expect(king.move([@located[0],@located[1] + 1])).to include(:alive => "Y", :colour => 'White', :valid => true)
    end

    it "Once a move is confirmed, a King updates it's current position" do
        king = King.new("White",["A",5])
        @located = ["A",5]
        @new_position = king.confirm(["A",6])
        expect(@located).to_not eq(@new_position)
    end
end