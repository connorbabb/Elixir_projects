defmodule StringMonoid do
  def identity, do: ""

  def combine(a, b) do
    a <> b
  end

  def combine_all([]), do: identity()
  def combine_all([x | xs]) do
    combine(x, combine_all(xs))
  end
end

IO.puts(StringMonoid.combine("hello", " world"))
IO.puts(StringMonoid.combine("", "HELLO"))
IO.puts(StringMonoid.combine_all(["Monoids", " ", "are", " ", "fun!"]))
IO.puts(StringMonoid.combine(StringMonoid.combine("String", "Monoid"), "Pattern"))
IO.puts(StringMonoid.combine_all([]))
# Output is the identity, or just ""
