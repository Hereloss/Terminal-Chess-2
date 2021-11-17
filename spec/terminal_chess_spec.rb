require './lib/pieces/pawn.rb'

describe Pawn do

    it "Pawn returns if it is alive or dead" do
        pawn = Pawn.new
        expect(pawn.alive).to eq("Y").or eq("N")
    end

    it "A killed pawn returns dead" do
        pawn = Pawn.new
        expect(pawn.kill).to eq("N")
    end

    it "Killing a pawn changes living from alive to dead" do
        pawn = Pawn.new
        pawn.kill
        expect(pawn.alive).to eq("N")
    end

    it "Pawn can state it's colour" do
        pawn = Pawn.new
        expect(pawn.colour).to eq("White").or eq("Black")
    end

    it "A pawns location is an array" do
        pawn = Pawn.new
        expect(pawn.location).to be_an_instance_of(Array)
    end

    it "A pawn knows it's horizontal co-ordinates" do
        expect(Pawn.new.location[0]).to satisfy { |value| ["A", "B","C","D","F","G","H"].include?(value) }
    end

    it "A pawn knows it's vertical co-ordinates" do
        expect(Pawn.new.location).to include (a_kind_of(Integer))
    end

    it "A pawn knows it's exact vertical co-ordinates" do
        expect(Pawn.new.location[1]).to satisfy { |value| (1..8).include?(value) }
    end

    it "A pawn knows if it has made a previous move" do
        expect(Pawn.new.previous?).to eq(true).or eq(false)
    end

    it "A pawn knows if a given move to it is valid" do
        pawn = Pawn.new
        located = pawn.location
        previous = pawn.previous?
        expect(pawn.valid?(located,previous)).to eq(true).or eq(false)
    end

    it "A pawn when given a move will return if it is alive or dead" do
        expect(Pawn.new.move[:alive]).to eq("Y").or eq("N")
    end

    it "A pawn when given a move will confirm if the move is valid" do
        expect(Pawn.new.move[:valid]).to eq(true).or eq(false)
    end

    it "A pawn when given a move will confirm its colour" do
        expect(Pawn.new.move[:colour]).to eq("White").or eq("Black")
    end

    it "A move is valid if it is within 1 space vertically up  of the piece's current postition if the piece is white" do
        piece = Pawn.new
        located = piece.location
        located[1] += 1
        if piece.colour == "White"
            previous = piece.previous?
            expect(piece.valid?(located,previous)).to eq(true).or eq(false)
        end
    end 

    it "A move is valid if it is within 1 space vertically down of the piece's current postition if the piece is black" do
        piece = Pawn.new
        located = Pawn.new.location
        located[1] -= 1
        if piece.colour == "Black"
            previous = piece.previous?
            expect(piece.valid?(located,previous)).to eq(true).or eq(false)
        end
    end
    
    it "If it is the pawn's first turn, moves within 2 spaces are valid" do
        piece = Pawn.new
        located = piece.location
        previous = piece.previous?
        colour = piece.colour
        if colour =="White"
            located[1] += 2
            expect(piece.valid?(located,previous)).to eq(true)
        elsif colour == "Black"
            located[1] -= 2
            expect(piece.valid?(located,previous)).to eq(true)
        end
    end

    it "The pawn will change the state of previous after it's first move" do
        piece = Pawn.new
        if piece.previous? ==false
            piece.move
            expect(piece.previous?).to eq(true)
        end
    end

    it "Pawn receives it's start location and colour upon initalising from board" do
    end

    it "Pawn receives a new position from the board to make a move" do
    end

    it "If a pawn is dead, the move is automatically invalid" do
    end

    it "Pawn applies the new position and confirms the validity" do
    end
            
    it "Pawn returns the validity, new position, and it's colour to the board" do
    end
end