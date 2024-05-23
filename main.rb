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
  @@max_guesses = 8

  def initialize
    @solution = Code.new
    @player = Player.new
    @round = 0
  end

  def getting_player_guess
    puts "#{@player.name} type in your guess:"
    begin
      player_guess = gets.chomp.to_s.split('')
      raise if player_guess.length != 4 || player_guess.all?(Integer)
    rescue
      puts 'Please make sure that you only type in 4 numbers between 1 and 9:'
      retry
    else
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
    guess_array.map.with_index do |guessed_number, i|
      return hint[i] = '🟢' if direct_hit?(guessed_number, i)
      return hint[i] = '🟡' if guess_included?(guessed_number, i)\

      hint[i] = '🔴'
    end
    hint
  end

  def code_cracked?(array)
    array == @solution
  end

  def check_round_counter(num)
    if num > @@max_guesses
      print 'That was your last guess. Game over!'
    else
      print "You have #{@@max_guesses - num} tries left"
    end
  end

  def round_counter
    round + 1
  end
end
