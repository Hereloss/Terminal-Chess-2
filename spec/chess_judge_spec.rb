require 'judge'

describe Judge do

  before do
    @board = double :board
    #working on this double! Also do board double
    @piece1 = double :piece, move: true
    @piece2 = double :piece, move: true
    @piece3 = double :piece, move: false
    @piece4 = double :piece, move: false
    @piece5 = double :piece, move: true
    @piece6 = double :piece, move: true
    @piece7 = double :piece, move: false
    @piece8 = double :piece, move: false
    @black_locations = {1 => @piece5,2 => @piece6,3 =>@piece7,4 => @piece8}
    @white_locations = {1 => @piece1,2 => @piece2,3 =>@piece3,4 => @piece4}
    @king_location = ["A",3]
    @piece_controller = double :piece_controller, location_king: @king_location, pieces_white: @white_locations, pieces_black: @black_locations
    @judge = Judge.new(@board,@piece_controller)
  end

  it "Upon being given a colour, will check if any pieces are putting the king in check" do
    expect(@judge).to respond_to :check?
  end

  it "Will check each individual piece if it puts the king into check" do
    piece = double :piece, move: true
    expect(@judge.puts_king_in_check?("move", piece)).to eq true
    piece2 = double :piece, move:false, is_a?:Pawn
    expect(@judge.puts_king_in_check?("move", piece2)).to eq false
  end

  it "Will check all the white pieces putting the black king in check for black" do
    expect(@judge).to receive(:check_valid_move_checking_white)
    expect(@judge).to receive(:puts_king_in_check)
    @judge.check?("Black")
    # expect(@judge.check?("Black")).to eq([@piece1,@piece2])
  end

  it "Will check all the black pieces putting the white king in check for white" do
    expect(@judge).to receive(:check_valid_move_checking_black)
    expect(@judge).to receive(:puts_king_in_check)
    @judge.check?("White")
    # expect(@judge.check?("White")).to eq([@piece5,@piece6])
  end
end