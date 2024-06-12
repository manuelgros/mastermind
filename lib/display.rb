# frozen_string_literal: true

# module to display game content more visually pleasing
module Display
  def code_colors(number)
    {
      '1' => "\e[101m  1  \e[0m ",
      '2' => "\e[43m  2  \e[0m ",
      '3' => "\e[44m  3  \e[0m ",
      '4' => "\e[45m  4  \e[0m ",
      '5' => "\e[46m  5  \e[0m ",
      '6' => "\e[104m  6  \e[0m ",
      '7' => "\e[42m  7  \e[0m ",
      '8' => "\e[47m  8  \e[0m ",
      '9' => "\e[102m  9  \e[0m "
    }[number]
  end

  def show_code(array)
    array.each { |num| print code_colors(num) }
  end

  def clue_colors(clue)
    {
      '!' => ' 🟩 ',
      '?' => ' 🟨 ',
      'x' => ' 🟥 '
    }[clue]
  end

  def show_clue(array)
    array.each { |sym| print clue_colors(sym) }
  end
end
