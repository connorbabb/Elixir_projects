defmodule StackFactory do
  def build_stack(initial_values) do
    %{type: :stack, values: initial_values}
  end
end

stack = StackFactory.build_stack([1, 2, 3])
string = StackFactory.build_stack(["hello", "hey", "hola"])
IO.inspect(stack)
IO.inspect(string)
