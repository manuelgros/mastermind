# frozen_string_literal: true

require_relative 'player'
require_relative 'computer'
require_relative 'game_notifications'

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
    puts "#{player.name}, do you want to be the CODEBREAKER (1) or CODEMAKER (2)?".colorize(:blue)
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
    puts 'Do you want to play another round? Y/N'.colorize(:blue)
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
    text_rounds_left
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
