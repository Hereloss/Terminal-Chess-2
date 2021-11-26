require 'game_controller.rb'

describe Game_Controller do

 context "Creation checks" do


  # it "Upon creation, creates 2 players and the board controller" do
  #   expect_any_instance_of(Game_Controller).to receive(:choice_input).and_return(1)
  #   game_control = Game_Controller.new
  #   expect(game_control.player1).to be_instance_of(Player)
  #   expect(game_control.player2).to be_instance_of(Player)
  #   expect(game_control.board_controller).to be_instance_of(Board_Controller)
  # end

  # it "Upon creation, puts the details about the application and gives a number of options" do
  #   expect do
  #     expect_any_instance_of(Game_Controller).to receive(:choice_input).and_return(4)
  #     game_control = Game_Controller.new
  #     end.to output("Welcome To Chess!\nWhat would you like to do?\n1. Play a game\n2. View the rules\n3. Quit\n").to_stdout
  # end

  # it "If option 1 is chosen, it begins a new game" do
  #   expect_any_instance_of(Game_Controller).to receive(:choice_input).and_return(1)
  #   game_control = Game_Controller.new

  # end

  # it "If option 2 is chosen, the rules are putsed and then the menu is re-opened" do
  #   expect_any_instance_of(Game_Controller).to receive(:choice_input).and_return(2)
  #   expect_any_instance_of(Game_Controller).to receive(:confirm).and_return("OK")
  #   game_control = Game_Controller.new
  # end

 end
end