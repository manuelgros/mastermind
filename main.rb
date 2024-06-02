# frozen_string_literal: true

require 'pry-byebug'

# ------------------ Modules ------------------
# Module for Code creation
# module CreateableCode
#   protected

#   def generate_code
#     Array.new(4).map { rand(1..9).to_s }
#   end

#   # Method to choose code (not complete yet) for when Player is CODEMAKER
#   # def choose_code
#   #   begin
#   #     code = gets.chomp.to_s.split('')
#   #     raise GameNotifications::FormatError if code.length != 4 || !code.all?('1'..'9')
#   #   rescu GameNotifications::FormatError
#   #     text_wrong_code
#   #     retry
#   #   else
#   #     code
#   #   end
# end

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

  attr_reader :computer_code, :guess_database

  def initialize
    # @computer_code = generate_code
    @guess_database = Array(1111..9999)
  end

  def getting_solution
    Array.new(4).map { rand(1..9).to_s }
  end

  # Method 1 to sort out the possible combinations from array of valid guesses, using reduce to return a new array
  # def reduce_guess_array(guessed_combination)
  #   array.reduce([]) do |combination, return_array|
  #     if check_guess(guessed_combination.to_s.split('')) == check_guess(combination.to_s.split(''))
  #       return_array.push(combination)
  #       return_array
  #     end
  #     return_array
  #   end
  # end

  # Method 2, using each and .delete method to mutate @guess_databse directly
  def reduce_guess_array_two(guessed_combination)
    array.each do |possible_combination|
      if check_guess(guessed_combination.to_s.split('')) != check_guess(possible_combination.to_s.split(''))
        @guess_database.delete(possible_combination)
      end
    end
  end

  # currently adjusted to be used with reduce_guess_array_two
  # takes always the first element from guess_databank as recommended in Swaszek strategy for Mastermind
  def getting_guess
    guess_database[0]
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

  attr_accessor :round, :player_guess, :human_codebreaker
  attr_reader :max_guesses, :solution, :player, :computer

  @@max_guesses = 8

  def initialize
    @computer = Computer.new
    @player = Player.new
    @solution = setting_solution
    @round = 0
    @player_guess = []
    @human_codebreaker = select_codebreaker
  end

  def self.start_game
    game = Game.new
    game.play_full_game
  end

  def play_full_game
    play_round until game_ends?
    play_again
  end

  def select_codebreaker
    puts 'Do you want to be the CODEBREAKER? Y/N'
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
    human_codebreaker ? player.getting_solution : computer.getting_solution
  end

  private

  def play_again
    puts 'Do you want to play another round? Y/N'
    answer = gets.chomp.upcase
    Game.start_game if answer == 'Y'
    exit if answer == 'N'
  end

  def setting_guess
    if human_codebreaker
      text_type_guess
      @player_guess = player.getting_guess
    else
      @player_guess = computer.getting_guess
    end
  end

  # def setting_guess
  #   if human_codebreaker == true
  #     text_type_guess
  #     begin
  #       @player_guess = gets.chomp.to_s.split('')
  #       raise GameNotifications::FormatError if @player_guess.length != 4 || !@player_guess.all?('1'..'9')
  #     rescue GameNotifications::FormatError
  #       text_wrong_code
  #       retry
  #     else
  #       @player_guess
  #     end
  #   else
  #     @player_guess = computer.take_guess
  #   end
  # end

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

  # .reduce maybe an easier solution here? --> later
  def check_guess(guess_array)
    hint = []
    guess_array.map.with_index do |guessed_number, i|
      next hint[i] = '🟢' if number_right?(guessed_number, i)
      next hint[i] = '🟡' if number_included?(guessed_number, i)

      hint[i] = '🔴'
    end
    text_hint(guess_array, hint)
    hint
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
    check_guess(setting_guess)
    add_round
    binding.pry
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
