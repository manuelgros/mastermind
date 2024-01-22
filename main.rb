# frozen_string_literal: true

# Class to create a code (currently: randomly)
class Code
  attr_reader :code

  def initialize
    @code = Array.new(4).map { |val| val = rand(1..9).to_s }
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
    @selected_code = Code.new
    @player = Player.new
    @round_counter = 0
  end

  def player_guess
    puts "#{@player.name} type in your guess:"
    guessed_code = gets.chomp.to_s.split('')
    if guessed_code.length != select_code.length
      puts 'Please make sure that you only type in 4 number between 1 and 9:'
      guessed_code = gets.chomp.to_s.split('')
    else
      guessed_code
    end
  end

  def check_for_hit(array1, index)
    array1[index] == @selected_code[index]
  end

  def check_for_included(array1, index)
    @selected_code.include?(array1[index])
  end

  # maybe check for hit or included at the same time with each_with_index. First included?, if no -> certain entree in seperate array at same index; if yes, same possition?, 
  # if no -> certain entree in seperate arrat at same index, if yes -> differetn entree etc....

end
