# frozen_string_literal: true

require 'pry-byebug'

# Modules for Notifications
module GameNotifications
  private

  # Custom error class for guess format
  class FormatError < StandardError; end

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
  # include CreateableCode
  include GameNotifications

  attr_reader :computer_code, :guess_database, :current_game

  def initialize(current_game)
    # @computer_code = generate_code
    @guess_database = Array(1111..9999)
    @current_game = current_game
  end

  def getting_solution
    Array.new(4).map { rand(1..9).to_s }
  end

  # Method 2, using each and .delete method to mutate @guess_databse directly. For Method 1 see /stuff
  # doesn't work -> check_guess call is spamming console and method seems to get stucl in endless loop
  def reduce_guess_array_two(solution_arr, guessed_combination)
    @guess_database.each do |possible_combination|
      if current_game.check_guess(solution_arr, guessed_combination) != current_game.check_guess(possible_combination.to_s.split(''), guessed_combination)
        @guess_database.delete(possible_combination)
      end
    end
  end

  # currently adjusted to be used with reduce_guess_array_two
  # takes always the first element from guess_databank as recommended in Swaszek strategy for Mastermind
  def getting_guess
    guess_database[0].to_s.split('')
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

  def getting_solution
    puts 'Type in a code (4 digits between 1 and 9) and the computer will try to crack it'
    solution = gets.chomp.to_s.split('')
    raise GameNotifications::FormatError if solution.length != 4 || !solution.all?('1'..'9')
  rescue GameNotifications::FormatError
    text_wrong_code
    retry
  else
    solution
  end

  def getting_guess
    guess = gets.chomp.to_s.split('')
    raise GameNotifications::FormatError if guess.length != 4 || !guess.all?('1'..'9')
  rescue GameNotifications::FormatError
    text_wrong_code
    retry
  else
    guess
  end
end

# Class for the Game functions
class Game
  include GameNotifications

  attr_accessor :round, :player_guess, :hint, :human_codebreaker
  attr_reader :max_guesses, :solution, :player, :computer, :game

  MAX_GUESSES = 8

  def initialize
    @computer = Computer.new(self)
    @player = Player.new
    @human_codebreaker = select_codebreaker
    @solution = setting_solution
    @round = 0
    @player_guess = []
    @hint = []
  end

  def self.start_game
    # game = Game.new
    # game.play_full_game
    Game.new.play_full_game
  end

  def play_full_game
    play_round until game_ends?
    play_again
  end

  def select_codebreaker
    puts "#{player.name}, do you want to be the CODEBREAKER? Y/N"
    begin
      answer = gets.chomp.upcase
      raise GameNotifications::FormatError unless answer.eql?('Y') || answer.eql?('N')
    rescue GameNotifications::FormatError
      puts 'Do you want to be the CODEBREAKER? Y/N'
      retry
    else
      answer == 'Y'
    end
  end

  def setting_solution
    human_codebreaker ? computer.getting_solution : player.getting_solution
  end

  # private

  # older version of setting_guess in \stuff
  def setting_guess
    if human_codebreaker
      text_type_guess
      @player_guess = player.getting_guess
    else
      @player_guess = computer.getting_guess
    end
  end

  def check_guess(solution_arr, guess_array)
    # hint = []
    guess_array.map.with_index do |guessed_number, i|
      next hint[i] = '🟢' if number_right?(solution_arr, guessed_number, i)
      next hint[i] = '🟡' if number_included?(solution_arr, guessed_number, i)

      hint[i] = '🔴'
    end
    hint
  end

  def number_right?(solution_arr, num, index)
    num == solution_arr[index]
  end

  # removes all elements if dierected_hit? == true before check for included?
  def exclude_direct_hits(array)
    temp_arr = []
    array.each_with_index do |n, i|
      temp_arr << n if array[i] != player_guess[i]
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
    # binding.pry
    check_guess(solution, setting_guess)
    text_hint(player_guess, hint)
    add_round
    computer.reduce_guess_array_two(solution, player_guess) unless human_codebreaker
  end

  def game_ends?
    if code_cracked?(solution, player_guess)
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
