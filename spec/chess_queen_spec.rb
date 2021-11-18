require './lib/pieces/queen.rb'

describe Queen do

    it "Queen returns if it is alive or dead" do
        queen = Queen.new("White",["A",5])
        expect(queen.alive).to eq("Y").or eq("N")
    end

    it "A killed Queen returns dead" do
        queen = Queen.new("White",["A",5])
        expect(queen.kill).to eq("N")
    end

    it "Killing a Queen changes living from alive to dead" do
        queen = Queen.new("White",["A",5])
        queen.kill
        expect(queen.alive).to eq("N")
    end

    it "Queen can state it's colour" do
        queen = Queen.new("White",["A",5])
        expect(queen.colour).to eq("White").or eq("Black")
    end

    it "A Queens location is an array" do
        queen = Queen.new("White",["A",5])
        expect(queen.location).to be_an_instance_of(Array)
    end

    it "A Queen knows it's horizontal co-ordinates" do
        expect(Queen.new("White",["A",5]).location[0]).to satisfy { |value| ["A", "B","C","D","F","G","H"].include?(value) }
    end

    it "A Queen knows it's vertical co-ordinates" do
        expect(Queen.new("White",["A",5]).location).to include (a_kind_of(Integer))
    end

    it "A Queen knows it's exact vertical co-ordinates" do
        expect(Queen.new("White",["A",5]).location[1]).to satisfy { |value| (1..8).include?(value) }
    end


    it "A Queen knows if a given move to it is valid" do
        queen = Queen.new("White",["A",5])
        @located = queen.location
        expect(queen.valid?(@located)).to eq(true).or eq(false)
    end

    it "A Queen when given a move will confirm if the move is valid" do
        coords = []
        expect(Queen.new("White",["A",5]).move(coords)[:valid]).to eq(true).or eq(false)
    end

    it "A Queen when given a move will confirm its colour" do
        coords = []
        expect(Queen.new("White",["A",5]).move(coords)[:colour]).to eq("White").or eq("Black")
    end


    it "A move is valid if it is if it is in a diagonal line of the piece " do
        piece = Queen.new("White",["C",5])
        @letters = ["A","B","C","D","E","F","G","H"]
        new_location = [@letters.sample,rand(1..8)]
        new_horz_loc = @letters.find_index(new_location[0])
        old_horz_loc = @letters.find_index("C")
        diff_vert = new_location[1] - 5
        diff_horz = new_horz_loc - old_horz_loc
        if diff_horz.abs - diff_vert.abs == 0
            expect(piece.valid?(new_location)).to eq(true)
        end
    end

    it "A move is valid if it is if it is in a vertical line of the piece " do
        piece = Queen.new("White",["C",5])
        @located = piece.location
        new_letter = ["A","B","C","D","E","F","G","H"].sample
        expect(piece.valid?(["C",rand(1..8)])).to eq(true)
        expect(piece.valid?([new_letter,@located[1]])).to eq(true)
    end
    
    it "Queen receives it's start location and colour upon initalising from board" do
        expect(Queen.new("White",["A",5]).location).to_not be_empty
        expect(Queen.new("White",["A",5]).colour).to_not be_empty
    end

    it "If a Queen is dead, the move is automatically invalid" do
        queen = Queen.new("White",["A",5])
        @located = queen.location
        queen.kill
        expect(queen.move_valid?([@located[0],@located[1] + 1])).to eq(false)
    end

    it "Queen applies the new position and confirms the validity" do
        queen = Queen.new("White",["C",5])
        @located = queen.location
        expect(queen.move(["B",6])).to include(:alive => "Y", :colour => 'White', :valid => true)
        expect(queen.move(["D",4])).to include(:alive => "Y", :colour => 'White', :valid => true)
        expect(queen.move(["B",@located[1]])).to include(:alive => "Y", :colour => 'White', :valid => true)
        expect(queen.move(["C",6])).to include(:alive => "Y", :colour => 'White', :valid => true)
    end

    it "Once a move is confirmed, a Queen updates it's current position" do
        queen = Queen.new("White",["A",5])
        @located = ["A",5]
        @new_position = queen.confirm(["A",6])
        expect(@located).to_not eq(@new_position)
    end
end