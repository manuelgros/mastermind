# frozen_string_literal: true

# Module containing the Game logic to be used on code/guesses
module GameLogic
  def check_guess(solution_arr, guess_array)
    hint = []
    guess_array.map.with_index do |guessed_number, i|
      next hint[i] = '🟢' if direct_hit?(solution_arr, guessed_number, i)
      next hint[i] = '🟡' if number_included?(solution_arr, guessed_number, i)

      hint[i] = '🔴'
    end
    hint
  end

  def direct_hit?(solution_arr, num, index)
    num == solution_arr[index]
  end

  # removes all elements if dierected_hit? == true before check for included?
  def exclude_direct_hits(array)
    temp_arr = []
    array.each_with_index do |n, i|
      temp_arr << n if array[i] != last_guess[i]
    end
    temp_arr
  end

  def number_included?(solution_arr, num, _index)
    exclude_direct_hits(solution_arr).include?(num)
  end

  def code_cracked?(solution_arr, guess_array)
    guess_array == solution_arr
  end
end
