# frozen_string_literal: true

require_relative 'game_notifications'
require_relative 'game'

# Class for Computer
class Computer
  # include CreateableCode
  include GameNotifications

  attr_reader :computer_code, :current_game
  attr_accessor :code_database, :code_database_raw

  def initialize(current_game)
    # @computer_code = generate_code
    @code_database = Array('1111'..'9999').reject { |num| num.include?('0') }
    # @code_database = code_database_raw.each { |num| code_database_raw.delete(num) if num.include?('0') }
    @current_game = current_game
  end

  def getting_solution
    Array.new(4).map { rand(1..9).to_s }
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
    # current_game.round.zero? ? code_database.sample.split('') : code_database[0].split('')
  end
end
