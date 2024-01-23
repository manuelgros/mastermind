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
    @ROUNDS_TO_PLAY = 8
  end

  def player_guess
    puts "#{@player.name} type in your guess:"
    player_guess = gets.chomp.to_s.split('')
    if player_guess.length != select_code.length
      puts 'Please make sure that you only type in 4 number between 1 and 9:'
      player_guess = gets.chomp.to_s.split('')
    else
      @round_counter += 1
      player_guess
    end
  end

  def direct_hit?(num, index)
    num == @solution[index]
  end

  def guess_included?(num)
    @solution.include?(num)
  end

  def check_guess(guess_array)
  hint = []
    guess_array.map.with_index do |val, i|
      if direct_hit?(val, i)
        hint[i] = "🟢"
      elsif guess_included?(val, i)
        hint[i] = "🟡"
      else
        hint[i] = "🔴"
      end
      hint
    end
  end

  def player_win?(array)
    array == @solution
  end

  def rounds_left(num)
    if num > @ROUNDS_TO_PLAY 
      print "No more tries left, sorry. Game over!"
    else
      print "You have #{@ROUNDS_TO_PLAY - num} tries left"
    end
  end
end
