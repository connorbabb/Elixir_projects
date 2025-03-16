# Beautiful Code:

# How to create clean, beautiful code:
# Use good variable/function names. These should be able to replace comments in most situations.
# Proper/consistent style with spacing and intentation.
# Single responsibility principle, make sure functions are small and do one specific task.
# Handle user input or program errors where we can.

# code - elixir beautiful_code.exs

defmodule BasicArithmeticOperations do
  def add_two_numbers(number_one, number_two) when is_number(number_one) and is_number(number_two) do
    number_one + number_two
  end

  def subract_two_numbers(number_one, number_two) when is_number(number_one) and is_number(number_two) do
    number_one - number_two
  end

  def square_number(number) when is_number(number) do
    number * number
  end
end

IO.puts(BasicArithmeticOperations.square_number(3))
IO.puts(BasicArithmeticOperations.square_number("cake"))
IO.puts(BasicArithmeticOperations.add_two_numbers(3, 5))

# Beauty principles:
# audacity and originality?
# It is very audacious and original since it makes the code very readable and maintainable.
# It also prevents the user from breaking our program, that wasn't something we had to add later,
# we thought about it and implemented it.

# Originality. It does this by shifting away from imperative, one-off calculations toward a more structured,
# composable, and error-aware approach. The most powerful insight is how consistent and maintainable this code is,
# a developer would see this and say, wow this is going to be really easy to add on to.

# Harmony. There isn't any friction. A function performs a single task, not interacting with any other function.
# All of the functions include the same syntax or grammar.
# And they all fit into the BasicArithmeticOperations module and describes exactly what it does.
