# frozen_string_literal: true

require 'pry-byebug'

# ------------------ Modules ------------------
# Module for Code creation
module CreateableCode
  protected

  def generate_code
    Array.new(4).map { rand(1..9).to_s }
  end

  # Method to choose code (not complete yet) for when Player is CODEMAKER
  # def choose_code
  #   begin
  #     code = gets.chomp.to_s.split('')
  #     raise GameNotifications::GuessError if code.length != 4 || !code.all?('1'..'9')
  #   rescue GameNotifications::GuessError
  #     text_wrong_code
  #     retry
  #   else
  #     code
  #   end
end

# Modules for Notifications
module GameNotifications
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
# Class for Computer
class Computer
  include CreateableCode

  attr_reader :computer_code, :guess_database

  def initialize
    @computer_code = generate_code
    # @guess_database = Array(1111..9999)
  end

  # def check_computer_guess(num)
  #   check_guess(num.to_s.split(''))
  # end
end

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
  include GameNotifications

  attr_accessor :round, :player_guess
  attr_reader :max_guesses, :solution, :player, :computer

  @@max_guesses = 8

  def initialize
    @computer = Computer.new
    @player = Player.new
    @solution = computer.computer_code
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

  private

  def play_again
    puts 'Do you want to play another round? Y/N'
    answer = gets.chomp.upcase
    Game.start_game if answer == 'Y'
    exit if answer == 'N'
  end

  def getting_player_guess
    text_type_guess
    begin
      @player_guess = gets.chomp.to_s.split('')
      raise GameNotifications::GuessError if @player_guess.length != 4 || !@player_guess.all?('1'..'9')
    rescue GameNotifications::GuessError
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

  # maybe use reduce instead of hint so that you have the hint array as return? (usefull for using in algorythm for computer guess)
  # def check_guess_two(guess_array)
  #   hint = guess_array.each_with_index.reduce(Array.new) do |hint_array, (number, i)|
  #     next hint_array[i] = '🟢' if number_right?(number, i)
  #     next hint_array[i] = '🟡' if number_included?(number, i)

  #     hint_array[i] = '🔴'
  #   end
  #   text_hint(guess_array, hint)
  # end

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

# Class for Game descriptions
class GameDescription
  def self.game_description
    puts "WELCOME TO MASTERMIND. Mastermind is a game of skill, in which two players engage in a battle of wits and
    logic. One of the players is called the CODEMAKER, and this player chooses, then hides, a secret code, which the
    other player, who is called the CODEBREAKER, must attempt to discover.
    The CODEMAKER generates a code which is made up of four numbers, ranging from 1 to 9
    (numbers can be used multiple times). The CODEBREAKER then tries to
    guess the code and receives a hint after each attempt:
    🟢 if the number at is at its correct position.
    🟡 if the number is indeed in the code BUT not at this position
    🔴 if the number is not in the code.\n\n"
  end

  def self.player_codebreaker
    puts "YOU ARE THE CODEBREAKER. You have 8 tries to crack the secret combination. If you are ready to take on the 
    CODEMAKER (computer) type in your name and lets begin!\n"
  end
end

# ------------------ Run Code ------------------
GameDescription.game_description 
GameDescription.player_codebreaker
Game.start_game
