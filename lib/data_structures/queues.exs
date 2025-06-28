ExUnit.start()

defmodule FunctionalQueue do
  def new(), do: {[], []}

  def empty({[], []}), do: true
  def empty(_), do: false

  def enqueue({front, rear}, element), do: {front, [element | rear]}

  def dequeue({[], []}), do: {[], []}
  def dequeue({[], rear}), do: dequeue({Enum.reverse(rear), []})
  def dequeue({[_h | t], rear}), do: {t, rear}

  def head({[], []}), do: nil
  def head({[], rear}), do: List.last(rear)
  def head({[h | _], _}), do: h

  def tail({[], []}), do: nil
  def tail({front, []}), do: List.last(front)
  def tail({_, [h | _]}), do: h

  def to_list({front, rear}), do: front ++ Enum.reverse(rear)

  def from_list(list), do: {list, []}

  def reverse(queue) do
    queue
    |> to_list()
    |> Enum.reverse()
    |> from_list()
  end

  def length({front, rear}), do: Enum.count(front) + Enum.count(rear)
end

defmodule FunctionalQueueTest do
  use ExUnit.Case
  alias FunctionalQueue

  test "empty queue checks" do
    assert FunctionalQueue.empty({[], []}) == true
    assert FunctionalQueue.empty({[1], []}) == false
  end

  test "enqueue and dequeue basics" do
    q = FunctionalQueue.new()
    q1 = FunctionalQueue.enqueue(q, :a)
    q2 = FunctionalQueue.enqueue(q1, :b)
    assert FunctionalQueue.to_list(q2) == [:a, :b]

    q3 = FunctionalQueue.dequeue(q2)
    assert FunctionalQueue.to_list(q3) == [:b]
  end

  test "head and tail behaviors" do
    q = FunctionalQueue.from_list([:x, :y, :z])
    assert FunctionalQueue.head(q) == :x
    assert FunctionalQueue.tail(q) == :z
  end

  test "convert between queue and list" do
    list = [:a, :b, :c]
    q = FunctionalQueue.from_list(list)
    assert FunctionalQueue.to_list(q) == list
  end

  test "reverse and length" do
    q = FunctionalQueue.from_list([1, 2, 3])
    reversed = FunctionalQueue.reverse(q)
    assert FunctionalQueue.to_list(reversed) == [3, 2, 1]
    assert FunctionalQueue.length(q) == 3
  end
end
