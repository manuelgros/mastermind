# frozen_string_literal: true

# Class to create a code (currently: randomly)
class Code
  attr_reader :possible_codes

  def initialize
    @possible_codes = Array(1..9).permutation(4).to_a
  end

  def select_code(database_array)
    database_array.sample
  end
end
