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
    @solution = Code.new
    @player = Player.new
    @round_counter = 0
  end

  def player_guess
    puts "#{@player.name} type in your guess:"
    player_guess = gets.chomp.to_s.split('')
    if player_guess.length != select_code.length
      puts 'Please make sure that you only type in 4 number between 1 and 9:'
      player_guess = gets.chomp.to_s.split('')
    else
      player_guess
    end
  end

  def direct_hit?(num, index)
    num == @solution[index]
  end

  def guess_included?(num, index)
    @solution.include?(num)
  end

  def check_guess(guess_array)
  hint = []
  guess_array.map.with_index do |val, i|
    if direct_hit?(val, i)
      hint[i] = 🟢
    elsif guess_included?(val, i)
      hint[i] = 🟡
    else
      hint[i] = 🔴
    end
    hint
  end

  # maybe check for hit or included at the same time with each_with_index. First included?, if no -> certain entree in seperate array at same index; if yes, same possition?, 
  # if no -> certain entree in seperate arrat at same index, if yes -> differetn entree etc....

end
