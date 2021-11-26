require 'judge'

describe Judge do

  it "Upon initializing, pulls in the board and piece controller classes" do
    expect(subject.board_controller).to be_instance_of(Board)
    expect(sbuejct.piece_controller).to be_instance_of(Pieces)
  end

  it "Upon being given a colour, will check if any pieces are putting the king in check" do
    
  end

  it "Will check all the white pieces putting the black king in check for black" do
  end

  it "Will check all the black pieces putting the white king in check for white" do
  end

  it "The judge will check for any piece if it can move to the Kings space" do
  end

  it "If a piece can move to the King's space, it will store this in the array to return to the controller" do
  end
end