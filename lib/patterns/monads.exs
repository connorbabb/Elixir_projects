defmodule Maybe do
  def unit(value), do: {:ok, value}

  def bind({:error, _} = error, _func), do: error
  def bind({:ok, value}, func), do: func.(value)
end

defmodule SafeMath do
  def safe_divide(_numerator, 0), do: {:error, :division_by_zero}
  def safe_divide(numerator, denominator), do: {:ok, numerator / denominator}
end

result1 = Maybe.unit(50)
  |> Maybe.bind(fn x -> SafeMath.safe_divide(x, 2) end)
  |> Maybe.bind(fn x -> SafeMath.safe_divide(x, 5) end)
  |> Maybe.bind(fn x -> SafeMath.safe_divide(x, 2) end)
IO.inspect(result1)

result2 = Maybe.unit(10)
  |> Maybe.bind(fn x -> SafeMath.safe_divide(x, 2) end)
  |> Maybe.bind(fn x -> SafeMath.safe_divide(x, 0) end)
  |> Maybe.bind(fn x -> SafeMath.safe_divide(x, 1) end)
IO.inspect(result2)
