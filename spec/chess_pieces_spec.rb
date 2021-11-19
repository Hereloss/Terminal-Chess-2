require './lib/pieces/pieces.rb'

describe Pieces do

    it "Can check if there is a piece at a given position" do
        pieces = Pieces.new
        locations = pieces.pieces_location_white
        filled_position = locations.key("P1")
        expect(pieces.piece_at_location(filled_position,"White","P")).to eq(true)
    end


    
end
