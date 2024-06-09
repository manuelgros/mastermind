# frozen_string_literal: true

require_relative 'game_notifications'
require_relative 'game'
# Class for the Player
class Player
  include GameNotifications

  attr_reader :name

  def initialize
    print 'Type in player name: '
    @name = gets.chomp.capitalize
  end

  def getting_combination
    GameNotifications::FormatError.secure_entry
  end
end
