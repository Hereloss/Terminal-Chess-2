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
        coordinates = coords
        unless ((@board[coordinates[0]][coordinates[1]] == "X") || (@board[coordinates[0]][coordinates[1]] == "O"))
            return @board[coordinates[0]][coordinates[1]]
        else
            return "E"
            #E is for empty here, to state no piece is there
        end
    end

    def converter(coords)
        @letters = ["A","B","C","D","E","F","G","H"]
        location = [coords[1].to_i,@letters.find_index(coords[0]).to_i + 1]
        location[0] = 8 - location[0]
        return location
    end

    def ray_empty?(from,to_loc,direction)
        current = converter(from)
        to = converter(to_loc)
        case direction
        when "up"
            current[0] -= 1
            until current == to
                if whats_there(current) != "E"
                    return false
                end
                current[0] -= 1
            end
            return true
        when "down"
            current[0] += 1
            until current == to
                if whats_there(current) != "E"
                    return false
                end
                current[0] += 1
            end
            return true
        when "left"
            current[1] -= 1
            until current == to
                if whats_there(current) != "E"
                    return false
                end
                current[1] -= 1
            end
            return true
        when "right"
            current[1] += 1
            until current == to
                if whats_there(current) != "E"
                    return false
                end
                current[1] += 1
            end
            return true
        when "up_right"
            current[0] -= 1
            current[1] += 1
            until current == to
                if whats_there(current) != "E"
                    return false
                end
                current[0] -= 1
                current[1] += 1
            end
            return true
        when "up_left"
            current[0] -= 1
            current[1] -= 1
            until current == to
                if whats_there(current) != "E"
                    return false
                end
                current[0] -= 1
                current[1] -= 1
            end
            return true
        when "down_right"
            current[0] += 1
            current[1] += 1
            until current == to
                if whats_there(current) != "E"
                    return false
                end
                current[0] += 1
                current[1] += 1
            end
            return true
        when "down_left"
            current[0] += 1
            current[1] -= 1
            until current == to
                if whats_there(current) != "E"
                    return false
                end
                current[0] += 1
                current[1] -= 1
            end
            return true
        end
    end

    def ray_trace(from,to)
        direction = compass(from,to)
        return ray_empty?(from,to,direction)
    end

    def compass(to,from)
       to_pos = converter(to)
       from_pos = converter(from)
       up = to_pos[0] > from_pos[0]
       down = to_pos[0] < from_pos[0]
       right = to_pos[1] < from_pos[1]
       left = to_pos[1] > from_pos[1]
       if up == true
            if left == true
                return "up_left"
            elsif right == true
                return "up_right"
            else
                return "up"
            end
        elsif down == true
            if left == true
                return "down_left"
            elsif right == true
                return "down_right"
            else
                return "down"
            end
        elsif right == true
            return "right"
        elsif left == true
            return "left"
        end
    end

    def update_board(from,to)
        move_from = converter(from)
        move_to = converter(to)
        piece_at_old_location = whats_there(move_from)
        @board[move_to[0]][move_to[1]] = piece_at_old_location
        parity = (move_from[0].to_i + move_from[1].to_i) % 2
        if parity == 0
            @board[move_from[0]][move_from[1]] = "X"
        elsif parity == 1
            @board[move_from[0]][move_from[1]] = "O"
        end
    end
end