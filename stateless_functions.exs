# Stateless Functions

defmodule Math do
  def add(a, b) do
    a + b
  end
  def multiply(a, b) do
    a * b
  end
end

IO.puts Math.add(6, 7)
IO.puts Math.multiply(6, 7)
