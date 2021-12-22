# frozen_string_literal: true

require './lib/pieces/rook'

describe Rook do
  it 'Rook returns if it is alive or dead' do
    rook = Rook.new('White', ['A', 5])
    expect(rook.alive).to eq('Y').or eq('N')
  end

  it 'A killed Rook returns dead' do
    rook = Rook.new('White', ['A', 5])
    expect(rook.kill).to eq('N')
  end

  it 'Killing a Rook changes living from alive to dead' do
    rook = Rook.new('White', ['A', 5])
    rook.kill
    expect(rook.alive).to eq('N')
  end

  it "Rook can state it's colour" do
    rook = Rook.new('White', ['A', 5])
    expect(rook.colour).to eq('White').or eq('Black')
  end

  it 'A Rooks location is an array' do
    rook = Rook.new('White', ['A', 5])
    expect(rook.location).to be_an_instance_of(Array)
  end

  it "A Rook knows it's horizontal co-ordinates" do
    expect(Rook.new('White', ['A', 5]).location[0]).to satisfy { |value|
                                                         %w[A B C D F G H].include?(value)
                                                       }
  end

  it "A Rook knows it's vertical co-ordinates" do
    expect(Rook.new('White', ['A', 5]).location).to include(a_kind_of(Integer))
  end

  it "A Rook knows it's exact vertical co-ordinates" do
    expect(Rook.new('White', ['A', 5]).location[1]).to satisfy { |value| (1..8).include?(value) }
  end

  it 'A Rook knows if a given move to it is valid' do
    rook = Rook.new('White', ['A', 5])
    @located = rook.location
    expect(rook.valid?(@located)).to eq(true).or eq(false)
  end

  it 'A Rook when given a move will confirm if the move is valid' do
    coords = []
    expect(Rook.new('White', ['A', 5]).move(coords)).to eq(true).or eq(false)
  end

  it 'A move is valid if it is if it is in a vertical line of the piece ' do
    piece = Rook.new('White', ['C', 5])
    @located = piece.location
    new_letter = %w[A B C D E F G H].sample
    expect(piece.valid?(['C', rand(1..8)])).to eq(true)
    expect(piece.valid?([new_letter, @located[1]])).to eq(true)
  end

  it "Rook receives it's start location and colour upon initalising from board" do
    expect(Rook.new('White', ['A', 5]).location).to_not be_empty
    expect(Rook.new('White', ['A', 5]).colour).to_not be_empty
  end

  it 'If a Rook is dead, the move is automatically invalid' do
    rook = Rook.new('White', ['A', 5])
    @located = rook.location
    rook.kill
    expect(rook.move_valid?([@located[0], @located[1] + 1])).to eq(false)
  end

  it 'Rook applies the new position and confirms the validity' do
    rook = Rook.new('White', ['A', 5])
    @located = rook.location
    expect(rook.move(['B', @located[1]])).to eq true
    expect(rook.move(['A', 6])).to eq true
  end

  it "Once a move is confirmed, a Rook updates it's current position" do
    rook = Rook.new('White', ['A', 5])
    @located = ['A', 5]
    @new_position = rook.confirm(['A', 6])
    expect(@located).to_not eq(@new_position)
  end
end
