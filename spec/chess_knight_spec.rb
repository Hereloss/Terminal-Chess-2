require './lib/pieces/knight.rb'

describe Knight do

    it "Knight returns if it is alive or dead" do
        knight = Knight.new("White",["A",5])
        expect(knight.alive).to eq("Y").or eq("N")
    end

    it "A killed Knight returns dead" do
        knight = Knight.new("White",["A",5])
        expect(knight.kill).to eq("N")
    end

    it "Killing a Knight changes living from alive to dead" do
        knight = Knight.new("White",["A",5])
        knight.kill
        expect(knight.alive).to eq("N")
    end

    it "Knight can state it's colour" do
        knight = Knight.new("White",["A",5])
        expect(knight.colour).to eq("White").or eq("Black")
    end

    it "A Knights location is an array" do
        knight = Knight.new("White",["A",5])
        expect(knight.location).to be_an_instance_of(Array)
    end

    it "A Knight knows it's horizontal co-ordinates" do
        expect(Knight.new("White",["A",5]).location[0]).to satisfy { |value| ["A", "B","C","D","F","G","H"].include?(value) }
    end

    it "A Knight knows it's vertical co-ordinates" do
        expect(Knight.new("White",["A",5]).location).to include (a_kind_of(Integer))
    end

    it "A Knight knows it's exact vertical co-ordinates" do
        expect(Knight.new("White",["A",5]).location[1]).to satisfy { |value| (1..8).include?(value) }
    end


    it "A Knight knows if a given move to it is valid" do
        knight = Knight.new("White",["A",5])
        @located = knight.location
        expect(knight.valid?(@located)).to eq(true).or eq(false)
    end

    it "A Knight when given a move will confirm if the move is valid" do
        coords = []
        expect(Knight.new("White",["A",5]).move(coords)[:valid]).to eq(true).or eq(false)
    end

    it "A Knight when given a move will confirm its colour" do
        coords = []
        expect(Knight.new("White",["A",5]).move(coords)[:colour]).to eq("White").or eq("Black")
    end


    it "A move is valid if it is an L Shape around of the piece's current postition " do
        piece = Knight.new("White",["C",5])
        @located = piece.location
        expect(piece.valid?(["D",@located[1] - 2])).to eq(true)
        expect(piece.valid?(["B",@located[1] - 2])).to eq(true)
        expect(piece.valid?(["D",@located[1] + 2])).to eq(true)
        expect(piece.valid?(["B",@located[1] + 2])).to eq(true)
        expect(piece.valid?(["E",@located[1] - 1])).to eq(true)
        expect(piece.valid?(["E",@located[1] - 1])).to eq(true)
        expect(piece.valid?(["A",@located[1] + 1])).to eq(true)
        expect(piece.valid?(["A",@located[1] + 1])).to eq(true)
    end
    

    it "Knight receives it's start location and colour upon initalising from board" do
        expect(Knight.new("White",["A",5]).location).to_not be_empty
        expect(Knight.new("White",["A",5]).colour).to_not be_empty
    end

    it "If a Knight is dead, the move is automatically invalid" do
        knight = Knight.new("White",["A",5])
        @located = knight.location
        knight.kill
        expect(knight.move_valid?([@located[0],@located[1] + 1])).to eq(false)
    end

    it "Knight applies the new position and confirms the validity" do
        knight = Knight.new("White",["A",5])
        @located = knight.location
        expect(knight.move(["B",@located[1] + 2])).to include(:alive => "Y", :colour => 'White', :valid => true)
    end

    it "Once a move is confirmed, a Knight updates it's current position" do
        knight = Knight.new("White",["A",5])
        @located = ["A",5]
        @new_position = knight.confirm(["A",6])
        expect(@located).to_not eq(@new_position)
    end
end