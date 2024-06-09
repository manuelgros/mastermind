# frozen_string_literal: true

require_relative 'game_notifications'
require_relative 'game'

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
