# frozen_string_literal: true

require 'colorize'

# Modules for Notifications
module GameNotifications
  private

  def text_wrong_code
    puts 'Please make sure that you only type in 4 numbers between 1 and 9:'.colorize(:red)
  end

  def text_player_lost
    puts "Sorry #{human_codebreaker ? player.name : 'computer'}, that was your last guess.
The right code was #{solution[0]} #{solution[1]} #{solution[2]} #{solution[3]}.
GAME OVER".colorize(:blue)
  end

  def text_player_won
    if round == 1
      puts "Good job #{human_codebreaker ? player.name : 'computer'}, you cracked the code on your firs try!!
A true Mastermind!\n\n".colorize(:green)
    else
      puts "Good job #{human_codebreaker ? player.name : 'computer'}, you cracked the code in #{round} tries!!
A true Mastermind!\n\n".colorize(:green)
    end
  end

  def text_rounds_left
    puts rounds_left > 1 ? "You have #{rounds_left} tries left\n\n".colorize(:light_yellow) : "LAST TRY!\n\n".colorize(:red)
  end

  def text_hint(last_guess, hint)
    puts "             | A  | B  | C  | D  |
Last Guess:  | #{last_guess[0]}  | #{last_guess[1]}  | #{last_guess[2]}  | #{last_guess[3]}  |
Hint:        | #{hint[0]} | #{hint[1]} | #{hint[2]} | #{hint[3]} |\n\n".colorize(:blue)
  end

  def text_type_guess
    puts "#{@player.name.upcase} TYPE IN YOUR".colorize(:blue)
    print "#{round + 1}. GUESS: ".colorize(:blue)
  end

  def text_player_role(condition)
    if condition
      puts "YOU ARE THE CODEBREAKER. You have 8 tries to crack the secret combination.\n\n".colorize(:blue)
    else
      puts "YOU ARE THE CODEMAKER. Choose a code of 4 numbers between 1 and 9. The computer will try to crack it.\n\n".colorize(:blue)
    end
  end
end
