# Terminal Chess

Terminal Chess is a fun game to play in the terminal for 2 human players. This game does not have AI support as of current (however, a basic AI may be implimented soon!). 
This game has support for all kinds of moves, check, checkmate, promoting pawns to queens, and castling.

## Installation

This can be played in the terminal of any code editor. Install the required Ruby gems with 'bundle install' and this will work in the terminal.

## Usage

To play, run the program in the terminal by opening irb, requiring the './lib/game_controller.rb' file and the game should start up with a welcome message. Alternatively, run the ruby file with "ruby './lib/game_controller.rb'" to begin playing outside of irb!

To play, simply follow the instructions to either read the rules, play, or quit. A copy of the rules are below:

Chess is a 2 player gam
One player is White, the other is Black. White moves first
Your goal is to checkmate the King - make it so it cannot escape Check
A king is in check when it would be taken the next turn by a piece
The pieces move as follows: Rook, straight line, Bishop, Diagonal lines, Queen, Straight line and Diagonal Lines'
puts 'Knight, An L shape (1 one way, 2 the other) in any direction, King, 1 square in any direction'
puts "Pawn, 1 square forward unless it is it's first move, when it can move 2 squares
A Pawn will be promoted to a Queen once it reaches the other side of the board.
Castling can only be done when a King and the respective Rook have both not moved and have a clear path between them.
Castling lets the King move 2 spaces to either the left or right, and puts the rook to the opposite side of it.
Any player can surrender by inputting "Surrender" instead of a move

Moves MUST be inputted in a specific format as per below:

Moves must be entered in the format: Piece, Position From, Position To'
For example, "Pawn,(E,2),(E,3)" is valid
But the following are not: 
(E,2),(E,3);Pawn,(E ,2),(E,3);Pawn,(E,2),(Et,3)

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
