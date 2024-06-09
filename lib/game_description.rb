# frozen_string_literal: true

require 'colorize'

# Class for Game descriptions
class GameDescription
  def self.game_description
    puts "WELCOME TO MASTERMIND. Mastermind is a game of skill, in which two players engage in a battle of wits and
    logic. One of the players is called the CODEMAKER, and this player chooses, then hides, a secret code, which the
    other player, who is called the CODEBREAKER, must attempt to discover.
    The CODEMAKER generates a code which is made up of four numbers, ranging from 1 to 9
    (numbers can be used multiple times). The CODEBREAKER then tries to
    guess the code and receives a hint after each attempt:
    
    🟢 if the number at is at its correct position.
    🟡 if the number is indeed in the code BUT not at this position
    🔴 if the number is not in the code.\n\n".colorize(:yellow)
  end
end
