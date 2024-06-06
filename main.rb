# frozen_string_literal: true

require 'pry-byebug'

# Modules for Notifications
module GameNotifications
  private

  # Custom error class for guess format
  class FormatError < StandardError
    def self.secure_entry
      combination = gets.chomp.to_s.split('')
      raise GameNotifications::FormatError if combination.length != 4 || !combination.all?('1'..'9')
    rescue GameNotifications::FormatError
      text_wrong_code
      retry
    else
      combination
    end

    def self.text_wrong_code
      puts 'Please make sure that you only type in 4 numbers between 1 and 9:'
    end
  end

  def text_player_lost
    puts "Sorry #{human_codebreaker ? player.name : 'computer'}, that was your last guess.
The right code was #{solution[0]} #{solution[1]} #{solution[2]} #{solution[3]}.
GAME OVER"
  end

  def text_player_won
    if round == 1
      puts "Good job #{human_codebreaker ? player.name : 'computer'}, you cracked the code on your firs try!!\nA true Mastermind!"
    else
      puts "Good job #{human_codebreaker ? player.name : 'computer'}, you cracked the code in #{round} tries!!\nA true Mastermind!"
    end
  end

  def text_rounds_left
    puts "You have #{@@max_guesses - add_round} tries left"
  end

  def text_hint(last_guess, hint)
    puts "| A  | B  | C  | D  |
| #{last_guess[0]}  | #{last_guess[1]}  | #{last_guess[2]}  | #{last_guess[3]}  |
| #{hint[0]} | #{hint[1]} | #{hint[2]} | #{hint[3]} |"
  end

  def text_type_guess
    puts "#{@player.name.upcase} TYPE IN YOUR"
    print "#{round + 1}. GUESS: "
  end

  def text_player_role(condition)
    if condition
      puts 'YOU ARE THE CODEBREAKER. You have 8 tries to crack the secret combination.'
    else
      puts 'YOU ARE THE CODEMAKER. Choose a code of 4 numbers between 1 and 9. The computer will try to crack it.'
    end
  end
end

# ------------------ Classes ------------------
# Class for Computer
class Computer
  # include CreateableCode
  include GameNotifications

  attr_reader :computer_code, :current_game
  attr_accessor :guess_database

  def initialize(current_game)
    # @computer_code = generate_code
    @guess_database = Array(1111..9999)
    @current_game = current_game
  end

  def getting_solution
    Array.new(4).map { rand(1..9).to_s }
  end

  # Method to get rid of unviable combinations after each guess, based on the returning hint
  def reduce_guess_array(hint_array, guessed_combination)
    guess_database.reduce([]) do |return_array, possible_combination|
      if current_game.check_guess(possible_combination.to_s.split(''), guessed_combination) == hint_array
        return_array << possible_combination
        return_array
      end
      @guess_database = return_array
    end
  end

  def getting_guess
    current_game.round.zero? ? guess_database[11].to_s.split('') : guess_database[0].to_s.split('')
  end
end

# Class for the Player
class Player
  include GameNotifications

  attr_reader :name

  def initialize
    print 'Type in player name: '
    @name = gets.chomp.capitalize
  end

  def getting_combination
    GameNotifications::FormatError.secure_entry
  end
end

# Class for the Game functions
class Game
  include GameNotifications

  attr_accessor :round, :last_guess, :last_hint, :human_codebreaker
  attr_reader :max_guesses, :solution, :player, :computer, :game

  MAX_GUESSES = 8

  def initialize
    @computer = Computer.new(self)
    @player = Player.new
    @human_codebreaker = select_codebreaker
    text_player_role(human_codebreaker)
    @solution = setting_solution
    @round = 0
    @last_guess = []
    @last_hint = []
  end

  def self.start_game
    Game.new.play_full_game
  end

  def play_full_game
    play_round until game_ends?
    play_again
  end

  def check_guess(solution_arr, guess_array)
    hint = []
    guess_array.map.with_index do |guessed_number, i|
      next hint[i] = '🟢' if number_right?(solution_arr, guessed_number, i)
      next hint[i] = '🟡' if number_included?(solution_arr, guessed_number, i)

      hint[i] = '🔴'
    end
    hint
  end

  private

  def select_codebreaker
    puts "#{player.name}, do you want to be the CODEBREAKER (1) or CODEMAKER (2)?"
    begin
      answer = gets.chomp
      raise GameNotifications::FormatError unless answer.eql?('1') || answer.eql?('2')
    rescue GameNotifications::FormatError
      puts 'Please select 1 for CODEBREAKER or 2 for CODEMAKER'
      retry
    else
      answer == '1'
    end
  end

  def setting_solution
    human_codebreaker ? computer.getting_solution : player.getting_combination
  end

  def setting_guess
    if human_codebreaker
      text_type_guess
      @last_guess = player.getting_combination
    else
      @last_guess = computer.getting_guess
    end
  end

  def number_right?(solution_arr, num, index)
    num == solution_arr[index]
  end

  # removes all elements if dierected_hit? == true before check for included?
  def exclude_direct_hits(array)
    temp_arr = []
    array.each_with_index do |n, i|
      temp_arr << n if array[i] != last_guess[i]
    end
    temp_arr
  end

  def number_included?(solution_arr, num, _index)
    exclude_direct_hits(solution_arr).include?(num)
  end

  def code_cracked?(solution_arr, guess_array)
    guess_array == solution_arr
  end

  def play_again
    puts 'Do you want to play another round? Y/N'
    answer = gets.chomp.upcase
    Game.start_game if answer == 'Y'
    exit if answer == 'N'
  end

  def rounds_left
    MAX_GUESSES - round
  end

  def add_round
    @round += 1
  end

  def play_round
    @last_hint = check_guess(solution, setting_guess)
    text_hint(last_guess, last_hint)
    add_round
    # binding.pry
    computer.reduce_guess_array(last_hint, last_guess) unless human_codebreaker
  end

  def game_ends?
    if code_cracked?(solution, last_guess)
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
end

# ------------------ Run Code ------------------
GameDescription.game_description 
# GameDescription.player_codebreaker
Game.start_game
