require 'player'

describe Player do 

  it "The player knows their colour" do
    player = Player.new("White")
    expect(player.colour).to eq("White")
  end

  it "The player knows if it is their turn" do
    player = Player.new("Black")
    expect(player.is_my_turn).to eq false
  end

  it "A player can start their turn" do
    player = Player.new("White")
    expect(player).to respond_to :start_turn
    player.start_turn
    expect(player.is_my_turn).to eq true
  end

  it "A player can end their turn" do
    player = Player.new("White")
    expect(player).to respond_to :end_turn
    player.end_turn
    expect(player.is_my_turn).to eq false
  end

  it "A player can input a move" do
    expect_any_instance_of(Player).to receive(:move_input).and_return("Bishop,(A,3),(A,5)".split(","))
    player = Player.new("White")
    expect(player).to respond_to :my_turn
    expect(player.my_turn).to eq(["Bishop",["A",3],["A",5]])
  end

  it "A typed move will be confirmed in the correct format" do
    move = "Bishop,(A,3),(A,5)".split(",")
    bad_move = "Bishop,(4,B),(A,5)".split(",")
    player = Player.new("White")
    expect(player).to respond_to :check_typing
    expect(player.check_typing(move)).to eq true
    expect(player.check_typing(bad_move)).to eq false
  end

  it "A incorrectly typed move will ask to be typed again" do
    player = Player.new("White")
    allow(player).to receive(:move_input).and_return("Bishop,(A,J),(A,5)".split(","),"Bishop,(A,3),(A,5)".split(","))
    expect(player.my_turn).to eq(["Bishop",["A",3],["A",5]])
  end

  it "A move that is typed without the commas or in the incorrect format will ask for a new move" do
    player = Player.new("White")
    expect_any_instance_of(Player).to receive(:move_input).and_return("A,3","Bishop,(A,3),(A,5)".split(","))
    expect(player.my_turn).to eq(["Bishop",["A",3],["A",5]])
  end



  it "A move can be inputted" do
    player = Player.new("White")
    expect_any_instance_of(Player).to receive(:gets).and_return("A,3")
    expect(player.move_input).to eq(["A","3"])
  end

  it "A correctly typed move will be formatted into an array to be received by the game controller" do
    player = Player.new("White")
    move = "Bishop,(A,3),(A,5)".split(",")
    expect(player.formatted(move)).to eq(["Bishop",["A",3],["A",5]])
  end

end