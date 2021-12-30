# frozen_string_literal: true

require 'game_controller'

describe Game_Controller do
  context 'Creation checks' do
    it 'Once created, lets you choose an option between 1 and 3' do
      allow_any_instance_of(Game_Controller).to receive(:choice_input) { 4 }
      expect { subject }.to output.to_stdout
    end

    it 'The choice input method lets you input one of the options' do
      allow_any_instance_of(Game_Controller).to receive(:menu) { true }
      allow_any_instance_of(Kernel).to receive(:gets).and_return('3')
      expect(subject.choice_input).to eq 3
    end

    it 'If the choice input is given the wrong input, it will not accept this' do
      allow_any_instance_of(Game_Controller).to receive(:menu) { true }
      allow_any_instance_of(Kernel).to receive(:gets).and_return('5', '2')
      expect(subject.choice_input).to eq 5
    end

    it 'If 1 is chosen, the game is started' do
      allow_any_instance_of(Game_Controller).to receive(:choice_input) { 1 }
      allow_any_instance_of(Game_Controller).to receive(:game_playing) { true }
      expect { subject }.to output.to_stdout
    end

    it 'If 2 is chosen, the rules are stated' do
      allow_any_instance_of(Game_Controller).to receive(:choice_input) { 2 }
      allow_any_instance_of(Game_Controller).to receive(:confirm) { true }
      allow_any_instance_of(Game_Controller).to receive(:play_game) { true }
      expect { subject }.to output.to_stdout
    end

    it 'If 3 is chosen, the game is ended' do
      allow_any_instance_of(Game_Controller).to receive(:choice_input) { 3 }
      allow_any_instance_of(Game_Controller).to receive(:exit) { 4 }
      expect(subject).to be_instance_of(Game_Controller)
    end

    it 'Each turn, the board is put and an input is asked for' do
      allow_any_instance_of(Game_Controller).to receive(:menu) { true }
      allow_any_instance_of(Game_Controller).to receive(:turn_take) { true }
      allow_any_instance_of(Game_Controller).to receive(:game_playing_test_break) { true }
      expect(subject.game_playing('White')).to eq true
      expect(subject.game_playing('Black')).to eq true
    end

    it 'Final test of test break method' do
      allow_any_instance_of(Game_Controller).to receive(:menu) { true }
      allow_any_instance_of(Game_Controller).to receive(:game_playing) { true }
      expect(subject.game_playing_test_break('Black')).to eq true
    end

    it 'Players can take turns' do
      board = double
      player1 = double
      player2 = double
      allow_any_instance_of(Game_Controller).to receive(:menu) { true }
      allow(player1).to receive(:my_turn).and_return(['A', 1])
      allow(player2).to receive(:my_turn).and_return(['A', 1])
      allow(player1).to receive(:end_turn).and_return(false)
      allow(player2).to receive(:end_turn).and_return(false)
      allow(board).to receive(:player_makes_move).and_return(true)
      allow(board).to receive(:queening)
      game_controller = Game_Controller.new(board, player1, player2)
      game_controller.stub(:check).and_return(false)
      expect(game_controller.turn_take('White')).to eq false
      expect(game_controller.turn_take('Black')).to eq false
    end

    it 'If a player makes an invalid move, it will make the player try again' do
      board = double
      player1 = double
      player2 = double
      allow_any_instance_of(Game_Controller).to receive(:menu) { true }
      allow(player1).to receive(:my_turn).and_return(['A', 1])
      allow(player2).to receive(:my_turn).and_return(['A', 1])
      allow(player1).to receive(:end_turn).and_return(false)
      allow(player2).to receive(:end_turn).and_return(false)
      allow(board).to receive(:player_makes_move).and_return(false, true)
      allow(board).to receive(:queening)
      game_controller = Game_Controller.new(board, player1, player2)
      game_controller.stub(:check).and_return(false)
      expect(game_controller.turn_take('White')).to eq false
      expect(game_controller.turn_take('Black')).to eq false
    end

    it 'If a player is in check, the board will let the players know this' do
      board = double
      allow_any_instance_of(Game_Controller).to receive(:menu) { true }
      allow(board).to receive(:check?).and_return(true)
      allow(board).to receive(:checkmate?).and_return(false)
      game_controller = Game_Controller.new(board)
      expect(game_controller.check('White')).to eq('Black')
      expect(game_controller.check('Black')).to eq('White')
    end

    it 'If a player wins, it will tell you this' do
      allow_any_instance_of(Game_Controller).to receive(:menu) { true }
      allow_any_instance_of(Game_Controller).to receive(:exit) { 4 }
      expect { subject.player_wins('White') }.to output.to_stdout
    end

    it 'The confirm method works' do
      allow_any_instance_of(Game_Controller).to receive(:menu) { true }
      allow_any_instance_of(Kernel).to receive(:gets).and_return('3')
      expect(subject.confirm).to eq '3'
    end
  end
end
