# frozen_string_literal: true

require_relative 'game_notifications'
require_relative 'game'
# Class for the Player
class Player
  include GameNotifications

  attr_reader :name

  def initialize
    print 'Type in player name: '.colorize(:blue)
    @name = gets.chomp.capitalize
  end

  def getting_combination
    combination = gets.chomp.to_s.split('')
    return combination unless combination.length != 4 || !combination.all?('1'..'9')

    text_wrong_code
    secure_entry
  end
end
