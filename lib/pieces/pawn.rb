class Pawn

    def initialize
        @living = "Y"
        @colour = "White"
        @current_location = ["A",5]
        @previously = false
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

    def move
        moves = {:alive => @living, :colour => @colour, :valid => true}
        @previously = true
        return moves
    end

    def previous?
        return @previously
    end

    def valid?(located,previous)
        case @colour
        when "White"
            if located[1].to_i == (@current_location[1].to_i + 1)
                return true
            else
                if previous == false
                    if located[1].to_i == (@current_location[1].to_i + 2)
                        return true
                    else
                        return false
                    end
                else
                    return false
                end
            end
        when "Black"
            if located[1].to_i == (@current_location[1].to_i - 1)
                return true
            else
                if previous == false
                    if located[1].to_i == (@current_location[1].to_i - 2)
                        return true
                    else
                        return false
                    end
                else
                    return false
                end
            end
        end
    end

    def move_valid?
    end
end