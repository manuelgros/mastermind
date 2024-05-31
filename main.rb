# frozen_string_literal: true

require 'pry-byebug'

# ------------------ Modules ------------------
# Module for Code creation
module CreateableCode
  private

  def generate_code
    Array.new(4).map { rand(1..9).to_s }
  end
end

# Modules for Notifications
module PrintableText
  private

  # Custom error class for guess format
  class GuessError < StandardError; end

  def text_wrong_code
    puts 'Please make sure that you only type in 4 numbers between 1 and 9:'
  end

  def text_player_lost
    puts "Sorry #{player.name}, that was your last guess.
The right code was #{solution[0]} #{solution[1]} #{solution[2]} #{solution[3]}.
GAME OVER"
  end

  def text_player_won
    if round == 1
      puts "Good job #{player.name}, you cracked the code on your firs try!!\nA true Mastermind!"
    else
      puts "Good job #{player.name}, you cracked the code in #{round} tries!!\nA true Mastermind!"
    end
  end

  def text_rounds_left
    puts "You have #{@@max_guesses - add_round} tries left"
  end

  def text_hint(player_guess, hint)
    puts "| A  | B  | C  | D  |
| #{player_guess[0]}  | #{player_guess[1]}  | #{player_guess[2]}  | #{player_guess[3]}  |
| #{hint[0]} | #{hint[1]} | #{hint[2]} | #{hint[3]} |"
  end

  def text_type_guess
    puts "#{@player.name.upcase} TYPE IN YOUR"
    print "#{round + 1}. GUESS: "
  end
end

# ------------------ Classes ------------------
# Class for the Player
class Player
  attr_reader :name

  def initialize
    print 'Type in player name: '
    @name = gets.chomp.capitalize
  end
end

# Class for the Game functions
class Game
  include CreateableCode
  include PrintableText

  attr_accessor :round, :player_guess
  attr_reader :max_guesses, :solution, :player

  @@max_guesses = 2

  def initialize
    @solution = generate_code
    @player = Player.new
    @round = 0
    @player_guess = []
  end

  def self.start_game
    game = Game.new
    game.play_full_game
  end

  def play_full_game
    play_round until game_ends?
    play_again
  end

  def play_again
    puts 'Do you want to play another round? Y/N'
    answer = gets.chomp.upcase
    Game.start_game if answer == 'Y'
    exit if answer == 'N'
  end

  private

  # Error not raised if guess is 4 letters FIX
  def getting_player_guess
    text_type_guess
    begin
      @player_guess = gets.chomp.to_s.split('')
      raise PrintableText::GuessError if @player_guess.length != 4 || !@player_guess.all?('1'..'9')
    rescue PrintableText::GuessError
      text_wrong_code
      retry
    else
      @player_guess
    end
  end

  def number_right?(num, index)
    num == @solution[index]
  end

  # removes all elements if dierected_hit? == true before check for included?
  def exclude_direct_hits(array)
    temp_arr = []
    array.each_with_index do |n, i|
      temp_arr << n if array[i] != player_guess[i]
    end
    temp_arr
  end

  def number_included?(num, _index)
    exclude_direct_hits(solution).include?(num)
  end

  def check_guess(guess_array)
    hint = []
    guess_array.map.with_index do |guessed_number, i|
      next hint[i] = '🟢' if number_right?(guessed_number, i)
      next hint[i] = '🟡' if number_included?(guessed_number, i)

      hint[i] = '🔴'
    end
    text_hint(guess_array, hint)
  end

  def code_cracked?(guess_array)
    guess_array == @solution
  end

  def rounds_left
    @@max_guesses - round
  end

  def add_round
    @round += 1
  end

  def play_round
    check_guess(getting_player_guess)
    add_round
    # binding.pry
  end

  def game_ends?
    if code_cracked?(player_guess)
      text_player_won
      true
    elsif rounds_left.zero?
      text_player_lost
      true
    end
  end
end

# ------------------ Run Code ------------------
Game.start_game
