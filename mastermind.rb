
class Game
    attr_accessor :code, :number_holes, :number_colors, :number_guesses

    @@colors = ["red", "green", "blue", "yellow", "orange", "violet", "pink", "teal"]

    def initialize(number_colors=6, number_holes=4, number_guesses=8)
        @number_colors = number_colors
        @number_holes = number_holes
        @number_guesses = number_guesses
        @guess_number = 0
        @guesses = []
    end

    def self.new_game
        game = Game.new
        rand_array = game.number_holes.times.map{ Random.rand(game.number_colors) }
        game.code = rand_array.map{ |i| @@colors[i] }
        board = []
        game.number_guesses.times{
            guess = game.guess
            board.push(guess)
            board.length().times{ |i|
                p board[i]
            }
            
        }
        
    end

    def guess
        @guess_number += 1
        @guesses[@guess_number] = @number_holes.times.map{ |i| puts "Enter color  ##{i + 1}: "; gets.chomp }
        @feedback = self.check(@guesses[@guess_number])
    end

    def check(guess)
        case
        when guess == self.code
            puts "You win!"
        end
        self.create_feedback(guess)
        @feedback
    end

    def create_feedback(guess)
        @feedback = []
        @number_holes.times{ |i|
            if guess[i].to_s == self.code[i].to_s
                @feedback.push("black")
            elsif self.code[i..].include?(guess[i])
                @feedback.push("white")
            else
                @feedback.push(" ") 
            end
        }
    end
end

class Peg
    attr_reader :color, :position

    def initialize(color, position)
        @color = color
        @position = position
    end
end    

Game.new_game


