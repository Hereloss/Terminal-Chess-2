require 'judge'

describe Judge do

  before do
    @board = double :board
    #working on this double! Also do board double
    @piece1 = double :piece1, move: true
    @piece2 = double :piece2, move: true
    @piece3 = double :piece3, move: false
    @piece4 = double :piece4, move: false, is_a?: Pawn
    @piece5 = double :piece5, move: true
    @piece6 = double :piece6, move: true, is_a?: Pawn
    @piece7 = double :piece7, move: false
    @piece8 = double :piece8, move: false
    @black_locations = {1 => @piece5,2 => @piece6,3 =>@piece7,4 => @piece8}
    @white_locations = {1 => @piece1,2 => @piece2,3 =>@piece3,4 => @piece4}
    @king_location = ["A",3]
    @piece_controller = double :piece_controller, location_king: @king_location, pieces_white: @white_locations, pieces_black: @black_locations
    @judge = Judge.new(@board,@piece_controller)
  end

  it "Upon being given a colour, will check if any pieces are putting the king in check" do
    expect(@judge).to respond_to :check?
  end

  it "Will check all the white pieces putting the black king in check for black" do
    @judge.check?("Black")
    expect(@judge.check?("Black")).to eq([@piece5,@piece6])
  end

  it "Will check all the black pieces putting the white king in check for white" do
    @judge.check?("White")
    expect(@judge.check?("White")).to eq([@piece1, @piece2])
  end
end