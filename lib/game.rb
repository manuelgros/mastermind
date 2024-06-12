# frozen_string_literal: true

require_relative 'player'
require_relative 'computer'
require_relative 'game_notifications'
require_relative 'game_logic'
require_relative 'display'

# Class for the Game functions
class Game
  include GameNotifications
  include GameLogic
  include Display

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
    Game.new.play
  end

  def play
    play_one_round until game_ends?
    play_again
  end

  private

  def select_codebreaker
    puts "#{player.name}, choose your role!
Type '1' to be the CODEBREAKER
Type '2' to be the CODEMAKER".colorize(:blue)
    answer = gets.chomp
    if answer != '1' && answer != '2'
      puts 'Unvalid input. Type 1 for CODEBREAKER or 2 for CODEMAKER'.colorize(:red)
      select_codebreaker
    else
      answer == '1'
    end
  end

  def play_one_round
    @last_hint = check_guess(solution, setting_guess)
    text_hint_visual(last_guess, last_hint)
    add_round
    text_rounds_left
    # binding.pry
    computer.reduce_guess_array(last_hint, last_guess) unless human_codebreaker
  end

  def add_round
    @round += 1
  end

  def rounds_left
    MAX_GUESSES - round
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

  def play_again
    puts 'Do you want to play another round? Type Y for YES.'.colorize(:blue)
    answer = gets.chomp.upcase
    if answer == 'Y'
      Game.start_game
    else
      puts 'Thanks for playing!'.colorize(:blue)
      exit
    end
  end
end
