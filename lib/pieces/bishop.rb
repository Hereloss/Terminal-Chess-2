class Bishop

    def initialize(colour,location)
        @living = "Y"
        @colour = colour
        @current_location = location
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

    def move(coords)
        moves = {:alive => @living, :colour => @colour, :valid => move_valid?(coords)}
        return moves
    end

    def confirm(coords)
        @current_location = coords
    end

    def valid?(located)
        current_horz_loc = @letters.find_index(@current_location[0])
        letter = located[0]
        new_horz_loc = @letters.find_index(letter)
        if ((located[1].to_i - @current_location[1].to_i).abs == (current_horz_loc.to_i  - new_horz_loc.to_i).abs) 
            return true
        else
            puts "Piece move not valid"
            return false
        end
    end

    def move_valid?(located)
        if @living == "N"
            return false
        else
            return valid?(located)
        end
    end
end

bishop = Bishop.new("White",["A",5])
puts bishop.valid?(["B",6])