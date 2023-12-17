# frozen_string_literal: true

# Class to create a code (currently: randomly)
class Code
  attr_reader :possible_codes

  def initialize
    @possible_codes = Array("1".."9").permutation(4).to_a
  end

  def select_code(database_array)
    database_array.sample.to_s
  end
end

# Class for the Player
class Player
  attr_reader :name

  def initialize
    @name = gets.chomp
  end
end

# Class for the Game functions
class Game
  def initialize
    @code_database = Code.new
    @selected_code = select_code(@code_database)
    @player = Player.new
  end

  def player_guess
    puts "#{@player.name} type in your guess:"
    guessed_code = gets.chomp.to_s.split('')
    if guessed_code.length != select_code.length
      puts 'Please make sure that you only type in 4 number between 1 and 9:'
      guessed_code = gets.chomp.to_s.split('')
    else 
      # code
    end
  end

  def check_for_hit(num)
    # for loop to check each position against each other for direct hit
  end

  def check_for_included
  # Method (.each ?) to check if value from guess_code is included in selected_code
  end

  # maybe check for hit or included at the same time with each_with_index. First included?, if no -> certain entree in seperate array at same index; if yes, same possition?, 
  # if no -> certain entree in seperate arrat at same index, if yes -> differetn entree etc....

end
