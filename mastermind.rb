require 'pry-byebug'

class Game
    attr_accessor :code, :number_holes, :number_colors, :number_guesses

    @@colors = ["red", "green", "blue", "yellow", "orange", "violet", "pink", "teal"]

    def initialize(number_colors=6, number_holes=4, number_guesses=8)
        @number_colors = number_colors
        @number_holes = number_holes
        @number_guesses = number_guesses
        @guess_number = 0
        @board = []
        @feedboard = []
    end

    def new_game
        self.set_code
        self.number_guesses.times{
            guess = self.guess
            @board.length.times{ |i|
                self.display(i)
            }
        } 
    end

    def display(i)
        p [@board[i], @feedboard[i]]
    end

    def set_code
        rand_array = self.number_holes.times.map{ Random.rand(self.number_colors) }
        self.code = rand_array.map{ |i| @@colors[i] }
    end

    def guess
        @board[@guess_number] = @number_holes.times.map{ |i| puts "Enter color  ##{i + 1}: "; gets.chomp }
        feedback = self.check(@board[@guess_number])
        @feedboard.push(feedback)
        @guess_number += 1
        @guesses
    end

    def check(guess)
        if guess == self.code
            puts "You win!"
        end
        feedback = []
        @number_holes.times{ |i|
            if guess[i].to_s == self.code[i].to_s
                feedback.push("black")
            elsif self.code.select.with_index{ |val, i| val != guess[i] }
                .include?(guess[i]) && self.code[i..].each_with_index{ |code, i| code.to_s == guess[i].to_s ? false : true }
                feedback.push("white")
            else
                feedback.push(" ") 
            end
        }
        feedback
    end
end   

game = Game.new
game.new_game


