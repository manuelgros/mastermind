# frozen_string_literal: true

require 'pry-byebug'

# Modules 
# Module for Code creation
module CreateableCode
  def generate_code
    Array.new(4).map { rand(1..9).to_s }
  end
end

# Class for the Player
class Player
  attr_reader :name

  def initialize
    @name = gets.chomp
  end
end

# Modules for Notifications
module PrintableText
  def text_wrong_code
    puts 'Please make sure that you only type in 4 numbers between 1 and 9:'
  end

  def text_player_lost
    puts " Sorry #{name}, that was your last guess. GAME OVER."
  end
end

# Class for the Game functions
class Game
  include CreateableCode, PrintableText
  attr_accessor :solution, :round, :player
  attr_reader :max_guesses

  @@max_guesses = 8

  def initialize
    @solution = generate_code
    @player = Player.new
    @round = 0
  end

  def getting_player_guess
    puts "#{@player.name} type in your guess:"
    begin
      player_guess = gets.chomp.to_s.split('')
      raise if player_guess.length != 4 || player_guess.all?(Integer)
    rescue
      text_wrong_code
      retry
    else
      player_guess
    end
  end

  def direct_hit?(num, index)
    num.to_s == @solution[index]
  end

  def guess_included?(num, _index)
    @solution.include?(num.to_s)
  end

  def check_guess(guess_array)
    hint = []
    guess_array.map.with_index do |guessed_number, i|
      next hint[i] = '🟢' if direct_hit?(guessed_number, i)
      next hint[i] = '🟡' if guess_included?(guessed_number, i)

      hint[i] = '🔴'
    end
    puts hint.to_s
  end

  def code_cracked?(array)
    array == @solution
  end

  def calc_rounds_left(num)
    if num > @@max_guesses
      print 'That was your last guess. Game over!'
    else
      print "You have #{@@max_guesses - num} tries left"
    end
  end

  def round_counter
    round + 1
  end

  def play_one_round
    check_guess(getting_player_guess)
    calc_rounds_left(round_counter)
  end

  def 
end

game = Game.new
# binding.pry
game.play_one_round
