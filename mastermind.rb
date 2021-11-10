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
        @code = []
        @whites = []
    end

    def self.new_game
        game = Game.new
        game.select_options
        game.run_game
    end

    def select_options
        @player = 0
        until @player == 1 || @player == 2
            puts "Enter 1 to play the guesser, enter 2 to play the setter: "
            @player = gets.chomp.to_i
            if @player != 1 && @player != 2
                puts "no way jose"
            end
        end
    end

    def run_game
        create_secret
        guess = nil
        guess_number = 0
        until guess_number == self.number_guesses || guess == self.code
            guess_number += 1
            case
            when @player == 1
                guess = self.player_guess
            when @player == 2
                guess = self.computer_guess
            end
            puts "\n"
            puts "\n"
            puts "\n"
            @board.length.times{ |i|
                p [@board[i], @feedboard[i]]
            }
            puts "\n"
        end
        if guess == self.code && @player == 1
            puts "\nYou win!"
            puts "\n"
        elsif guess == self.code && @player == 2
            puts "\nComputer wins!"
            puts "\n"
        elsif guess != self.code && @player == 1
            puts "\nYou lose!"
            puts "\n"
        else
            puts "\nComputer loses!"
            puts "\n"
        end
    end

    def create_secret
        case
        when @player == 1
            rand_array = number_holes.times.map{ Random.rand(self.number_colors) }
            self.code = rand_array.map{ |i| @@colors[i] }
        when @player == 2
            @number_holes.times{ |i| 
                puts "Enter a color #{@@colors[..@number_colors - 1]}: "
                answer = gets.chomp
                code.push(answer)
            }
        end
    end

    def player_guess
        guess = @number_holes.times.map{ |i|
                                         answer = nil
                                         until @@colors[..self.number_colors - 1].include?(answer) 
                                            puts "\nEnter color ##{i + 1}(#{@@colors[..self.number_colors - 1]}):  "
                                            answer = gets.chomp
                                         end
                                         answer
                                        }
        @board[@guess_number] = guess
        create_feedback(guess)
        @guess_number += 1
        guess
    end

    def computer_guess
        rand_array = self.number_holes.times.map{ Random.rand(self.number_colors) }
        init_guess = rand_array.map{ |i| @@colors[i] }
        if @lastfeed
            @whites = @lastfeed.map.with_index{ |v, i| v == 'white' ? @board[-1][i] : nil }
            @white_values = @whites.compact
            p @white_values
            guess = init_guess.map.with_index{ |v, i| 
                if @lastfeed[i] == 'black'
                    @board[-1][i]
                elsif @lastfeed[i] == 'white'
                    if @white_values && @whites[0] != @board[-1][i]
                        p @whites_values
                        @white_values.pop()
                    elsif init_guess[i] != @board[-1][i]
                        init_guess[i]
                    else
                        @@colors[Random.rand(self.number_colors)]
                    end
                elsif @white_values.any?()
                    p @white_values
                    @white_values.pop()
                else 
                    init_guess[i]
                end                     
            } 
            
        else
            guess = init_guess
        end
        @board[@guess_number] = guess
        create_feedback(guess)
        @guess_number += 1
        guess
    end

    def create_feedback(guess)
        feedback = self.check_guess(@board[@guess_number])
        @feedboard.push(feedback)
        @lastfeed = feedback
        feedback
    end

    def check_guess(guess)
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