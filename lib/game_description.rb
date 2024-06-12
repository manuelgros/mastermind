# frozen_string_literal: true

require 'colorize'

# Class for Game descriptions
class GameDescription
  def self.game_description
    puts "WELCOME TO MASTERMIND. Mastermind is a game of skill, in which two players engage in a battle of wits and
    logic. In this version you will compete with a computer opponent. One will take on the role of CODEMAKER, who
    creates a secret code, which the other player, who is called the CODEBREAKER, must attempt to discover.
    The CODEMAKER generates a code which is made up of four numbers, ranging from 1 to 9
    (numbers can be used multiple times). The CODEBREAKER then tries to
    guess the code and receives a hint after each attempt:\n".colorize(:blue)

    puts "🟢 #{'=> if the number at is at its correct position'.colorize(:green)}
🟡 #{'=> if the number is in code BUT not at this position'.colorize(:yellow)}
🔴 #{'=> if the number is not in the code'.colorize(:red)}\n\n"
  end
end
