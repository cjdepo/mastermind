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

    def self.new_game
        game = Game.new
        game.start_game
    end

    def start_game
        self.set_secret
        guess_number = 0
        guess = 0
        until guess_number == self.number_guesses || guess == self.code
            guess_number += 1
            guess = self.guess
            puts "\n"
            puts "\n"
            puts "\n"
            @board.length.times{ |i|
                self.display(i)
            }
            puts "\n"
        end
        if guess == self.code
            puts "\nYou win!"
            puts "\n"
        else 
            puts "\nYou lose!"
            puts "\n"
        end
    end

    def display(i)
        p [@board[i], @feedboard[i]]
    end

    def set_secret
        rand_array = self.number_holes.times.map{ Random.rand(self.number_colors) }
        self.code = rand_array.map{ |i| @@colors[i] }
    end

    def guess
        guess = @number_holes.times.map{ |i|
                                         answer = nil
                                         until @@colors[..self.number_colors - 1].include?(answer) 
                                            puts "\nEnter color ##{i + 1}(#{@@colors[..self.number_colors - 1]}):  "
                                            answer = gets.chomp
                                         end
                                         answer
                                        }
        @board[@guess_number] = guess
        feedback = self.check(@board[@guess_number])
        @feedboard.push(feedback)
        @guess_number += 1
        guess
    end

    def check(guess)
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

Game.new_game


