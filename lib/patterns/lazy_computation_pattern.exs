defmodule LazyRandomStream do
  def stream(min, max) do
    Stream.repeatedly(fn -> :rand.uniform(max - min + 1) + min - 1 end)
  end
end

stream = LazyRandomStream.stream(10, 20)
IO.puts(Enum.at(stream, 0))
IO.puts(Enum.at(stream, 1))
IO.puts(Enum.at(stream, 2))
IO.puts(Enum.at(stream, 3))
IO.puts(Enum.at(stream, 4))
