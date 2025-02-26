# Stateful Functions:

# Definition:
# Stateful functions in Elixir maintain state across function calls without using processes.
# State is passed explicitly through recursive function calls since variables are immutable.

# Example:

# Code - elixir stateful_functions.exs

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
