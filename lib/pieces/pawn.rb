class Pawn

    def initialize(colour,location)
        @living = "Y"
        @colour = colour
        @current_location = location
        @previously = false
        @letters = ["A","B","C","D","E","F","G","H"]
    end

    def alive
        return @living
    end

    def kill
        @living = "N"
        return @living
    end

    def colour
        return @colour
    end

    def location
        return @current_location
    end

    def move(coords,taking)
        moves = {:alive => @living, :colour => @colour, :valid => move_valid?(coords,@previously,taking)}
        return move_valid?(coords,@previously,taking)
    end

    def confirm(coords)
        @current_location = coords
        @previously = true
    end

    def previous?
        return @previously
    end

    def valid?(located,previous,taking)
        unless (taking == true || located[0] == @current_location[0])
            puts "Piece move not valid"
            return false
        end
        case @colour
        when "White"
            return white_valid(located,previous,taking)
        when "Black"
            return black_valid(located,previous,taking)
        end
    end

    def move_valid?(located,previous,taking)
        if @living == "N"
            return false
        else
            return valid?(located,previous,taking)
        end
    end

    def white_valid(located,previous,taking)
        if taking == true
            return white_takes(located)
        end
        if located[1].to_i == (@current_location[1].to_i + 1)
            return true
        else
            if previous == false
                if located[1].to_i == (@current_location[1].to_i + 2)
                    return true
                end
            end
            puts "Piece move not valid"
            return false
        end
    end

    def black_valid(located,previous,taking)
        if taking == true
            return black_takes(located)
        end
        if located[1].to_i == (@current_location[1].to_i - 1)
            return true
        else
            if previous == false
                if located[1].to_i == (@current_location[1].to_i - 2)
                    return true
                end
            end
            puts "Piece move not valid"
            return false
        end
    end

    def white_takes(located)
        current_horz_loc = @letters.find_index(@current_location[0])
        letter = located[0]
        new_horz_loc = @letters.find_index(letter)
        if (located[1].to_i == (@current_location[1].to_i + 1) && (current_horz_loc + 1 == new_horz_loc || current_horz_loc - 1 == new_horz_loc))
            return true
        else
            return false
        end
    end

    def black_takes(located)
        current_horz_loc = @letters.find_index(@current_location[0])
        letter = located[0]
        new_horz_loc = @letters.find_index(letter)
        if (located[1].to_i == (@current_location[1].to_i - 1) && (current_horz_loc + 1 == new_horz_loc || current_horz_loc - 1 == new_horz_loc))
            return true
        else
            return false
        end
    end
end
