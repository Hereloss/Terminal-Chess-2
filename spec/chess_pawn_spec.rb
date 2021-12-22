# frozen_string_literal: true

require './lib/pieces/pawn'

describe Pawn do
  it 'Pawn returns if it is alive or dead' do
    pawn = Pawn.new('White', ['A', 5])
    expect(pawn.alive).to eq('Y').or eq('N')
  end

  it 'A killed pawn returns dead' do
    pawn = Pawn.new('White', ['A', 5])
    expect(pawn.kill).to eq('N')
  end

  it 'Killing a pawn changes living from alive to dead' do
    pawn = Pawn.new('White', ['A', 5])
    pawn.kill
    expect(pawn.alive).to eq('N')
  end

  it "Pawn can state it's colour" do
    pawn = Pawn.new('White', ['A', 5])
    expect(pawn.colour).to eq('White').or eq('Black')
  end

  it 'A pawns location is an array' do
    pawn = Pawn.new('White', ['A', 5])
    expect(pawn.location).to be_an_instance_of(Array)
  end

  it "A pawn knows it's horizontal co-ordinates" do
    expect(Pawn.new('White', ['A', 5]).location[0]).to satisfy { |value|
                                                         %w[A B C D F G H].include?(value)
                                                       }
  end

  it "A pawn knows it's vertical co-ordinates" do
    expect(Pawn.new('White', ['A', 5]).location).to include(a_kind_of(Integer))
  end

  it "A pawn knows it's exact vertical co-ordinates" do
    expect(Pawn.new('White', ['A', 5]).location[1]).to satisfy { |value| (1..8).include?(value) }
  end

  it 'A pawn knows if it has made a previous move' do
    expect(Pawn.new('White', ['A', 5]).previous?).to eq(true).or eq(false)
  end

  it 'A pawn knows if a given move to it is valid' do
    pawn = Pawn.new('White', ['A', 5])
    @located = pawn.location
    previous = pawn.previous?
    expect(pawn.valid?(@located, previous, false)).to eq(true).or eq(false)
  end

  it 'A pawn knows if a given move to it is valid' do
    pawn = Pawn.new('Black', ['A', 5])
    @located = pawn.location
    previous = pawn.previous?
    expect(pawn.valid?(@located, previous, false)).to eq(true).or eq(false)
  end

  it 'A pawn when given a move will confirm if the move is valid' do
    coords = []
    taking = true
    expect(Pawn.new('White', ['A', 5]).move(coords, taking)).to eq(true).or eq(false)
  end

  it "A move is valid if it is within 1 space vertically up  of the piece's current postition if the piece is white" do
    piece_1 = Pawn.new('White', ['A', 5])
    @located = piece_1.location
    if piece_1.colour == 'White'
      previous = piece_1.previous?
      expect(piece_1.valid?([@located[0], @located[1] + 1], previous, false)).to eq(true)
    end
  end

  it "A move is valid if it is within 1 space vertically down of the piece's current postition if the piece is black" do
    piece_2 = Pawn.new('Black', ['A', 5])
    @located = piece_2.location
    if piece_2.colour == 'Black'
      previous = piece_2.previous?
      expect(piece_2.valid?([@located[0], @located[1] - 1], previous, false)).to eq(true)
    end
  end

  it "If it is the pawn's first turn, moves within 2 up spaces are valid if white" do
    piece_3 = Pawn.new('White', ['A', 5])
    @located = piece_3.location
    previous = false
    colour = piece_3.colour
    if piece_3.colour == 'White'
      previous = piece_3.previous?
      expect(piece_3.valid?([@located[0], @located[1] + 2], previous, false)).to eq(true)
    end
  end

  it "If it is the pawn's first turn, moves within 2 down spaces are valid if black" do
    piece_4 = Pawn.new('Black', ['A', 5])
    @located = piece_4.location
    previous = false
    colour = piece_4.colour
    if piece_4.colour == 'Black'
      previous = piece_4.previous?
      expect(piece_4.valid?([@located[0], @located[1] - 2], previous, false)).to eq(true)
    end
  end

  it "The pawn will change the state of previous after it's first move" do
    piece = Pawn.new('White', ['A', 5])
    if piece.previous? == false
      piece.move([], false)
      piece.confirm([])
      expect(piece.previous?).to eq(true)
    end
  end

  it "Pawn receives it's start location and colour upon initalising from board" do
    expect(Pawn.new('White', ['A', 5]).location).to_not be_empty
    expect(Pawn.new('White', ['A', 5]).colour).to_not be_empty
  end

  it 'Pawn receives a new position from the board to make a move' do
  end

  it 'If a pawn is dead, the move is automatically invalid' do
    pawn = Pawn.new('White', ['A', 5])
    @located = pawn.location
    previous = true
    pawn.kill
    expect(pawn.move_valid?([@located[0], @located[1] + 1], previous, false)).to eq(false)
  end

  it 'Pawn applies the new position and confirms the validity' do
    pawn = Pawn.new('White', ['A', 5])
    @located = pawn.location
    expect(pawn.move([@located[0], @located[1] + 1], false)).to eq true
  end

  it 'If a pawn is taking, a single diagonal move down is valid for blacK' do
    pawn = Pawn.new('Black', ['C', 5])
    @located = ['C', 5]
    expect(pawn.move(['D', 4], true)).to eq true
    expect(pawn.move(['B', 4], true)).to eq true
  end

  it 'If a pawn is taking, a single diagonal move up is valid for white' do
    pawn = Pawn.new('White', ['C', 5])
    @located = ['C', 5]
    expect(pawn.move(['D', 6], true)).to eq true
    expect(pawn.move(['B', 6], true)).to eq true
  end

  it "Once a move is confirmed, a pawn updates it's current position" do
    pawn = Pawn.new('White', ['A', 5])
    @located = ['A', 5]
    @new_position = pawn.confirm(['A', 6])
    expect(@located).to_not eq(@new_position)
  end

  it 'If a pawn is not taking a piece, it should not move from side to side' do
    pawn = Pawn.new('White', ['C', 5])
    expect(pawn.valid?(['D', 6], false, false)).to eq(false)
  end
end
