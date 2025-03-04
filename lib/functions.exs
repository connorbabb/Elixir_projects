# Stateless Functions:

# Definition:
# Functions are stateless by default in Elixir, meaning that they don't retain any state between calls.
# If we call the same function with the same inputs, it will give us the same output every single time.
# These make these functions reliable and pure, these are great for concurrency.
# With no shared state multiple functions can execute in parallel safety.

# Example:
# Real-world scenario: A real world scenario of using stateless Elixir functions could be
# creating an online calculator. If the user types in 2 + 3 and presses the enter or compute key the program
# would call the add function with the parameters 2 and 3 and return 5. Since this is a stateless function
# the output only depends on the inputs or parameters, so if we gave the calculator add/2 function the same inputs
# it would continue to return 5.

# Code - elixir stateless_functions.exs

defmodule Functions do
  def add(a, b) do
    a + b
  end

  def multiply(a, b) do
    a * b
  end

  def reverse_string(string) do
    string = String.reverse(string)
    string
  end

  def check_palindrome(string) do
    if string == String.reverse(string) do
      true
    else
      false
    end
  end

  def format_people(people) do
    Enum.map(people, fn person ->
      "#{person.name} is #{person.age} years old"
    end)
  end
end

IO.puts(Functions.add(6, 7))
IO.puts(Functions.multiply(6, 7))
IO.puts(Functions.check_palindrome("racecar"))
IO.puts(Functions.reverse_string("connor"))

# Elixir doesn't have dictionaries, instead they use maps,
# where keys are mapped to values, the key name: is mapped to the value "Alice".
# Atoms can be either defined by :atom or atom: with maps it is more common to do atom: "value".
# You can still use :atom but it has to be used with a longer syntax :atom => "value". Just use atom: for maps.
people = [
  %{:name => "Alice", age: 30},
  %{name: "Bob", age: 25},
  %{name: "Charlie", age: 35}
]

formatted_people = Functions.format_people(people)
IO.inspect(formatted_people)


# Recurrsive Functions:

defmodule Counter do
  def count(n, limit) when n > limit do
    IO.puts("Done.")
  end

  def count(n, limit) do
    IO.puts("Current count: #{n}")
    count(n + 1, limit)
  end
  # Accumulators:
  # This first function is what the user calls, this function will call other PRIVATE functions below,
  # But first it gives it an accumulator that starts at 0, since we want to sum them.

  # This is also a shorthand for really short functions,
  # using a comma and colon to make it all a single line of code.
  def sum(list), do: sum(list, 0)

  # This is another shorthand function, but it's private so it can only be called inside this module, called "defp"
  # This is the base case, if the list is empty, we just want to return the acc.
  defp sum([], acc), do: acc

  # Last case, this function is where the recursion happens until the the base case is met.
  # It will take the acc and add the head to it then run the same function this time only using,
  # the tail(everything except the head) and the acc.
  defp sum([head | tail], acc) do
    sum(tail, acc + head)
  end
end

Counter.count(1, 5)
IO.puts(Counter.sum([2,3,6,8,10]))
