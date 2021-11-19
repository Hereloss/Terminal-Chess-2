class Board

    attr_reader :board

    def initialize
        @board = [[8, "R","N","B","Q","K","B","N","R"],
                 [7, "P","P","P","P","P","P","P","P"],
                 [6, "O","X","O","X","O","X","O","X"],
                 [5, "X","O","X","O","X","O","X","O"],
                 [4, "O","X","O","X","O","X","O","X"],
                 [3, "X","O","X","O","X","O","X","O"],
                 [2, "P","P","P","P","P","P","P","P"],
                 [1, "R","N","B","Q","K","B","N","R"],
                 [0, "A","B","C","D","E","F","G","H"]]
    end

    def whats_there(coords)
        coordinates = converter(coords)
        unless ((@board[coordinates[0]][coordinates[1]] == "X") || (@board[coordinates[0]][coordinates[1]] == "O"))
            return @board[coordinates[0]][coordinates[1]]
        else
            return "E"
            #E is for empty here, to state no piece is there
        end
    end

    def converter(coords)
        @letters = ["A","B","C","D","E","F","G","H"]
        location = [coords[1],@letters.find_index(coords[0]).to_i + 1]
        location[0] = 8 - location[0]
        print location
        return location
    end

    def whats_there_set(ray)
    end

    def ray(from,to,direction)
        case direction
        when up
        when down
        when left
        when right
        when up_right
        when up_left
        when down_right
        when down_left
        end
    end

    def ray_trace
        return true
    end
end