# frozen_string_literal: true

require_relative 'game_notifications'
require_relative 'game'

# Class for Computer
class Computer
  # include CreateableCode
  include GameNotifications

  attr_reader :computer_code, :current_game
  attr_accessor :code_database

  def initialize(current_game)
    # @computer_code = generate_code
    @code_database = Array('1111'..'9999')
    @current_game = current_game
  end

  def getting_solution
    code_database.sample.split('')
  end

  # Method to get rid of unviable combinations after each guess, based on the returning hint
  def reduce_guess_array(hint_array, guessed_combination)
    code_database.reduce([]) do |return_array, possible_combination|
      if current_game.check_guess(possible_combination.split(''), guessed_combination) == hint_array
        return_array << possible_combination
        return_array
      end
      @code_database = return_array
    end
  end

  def getting_guess
    current_game.round.zero? ? code_database[11].split('') : code_database[0].split('')
  end
end
