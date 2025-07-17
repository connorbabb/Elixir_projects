ExUnit.start()

defmodule Queue do
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

defmodule QueueTest do
  use ExUnit.Case
  alias Queue

  test "empty queue checks" do
    assert Queue.empty({[], []}) == true
    assert Queue.empty({[1], []}) == false
  end

  test "enqueue and dequeue" do
    q = Queue.new()
    q1 = Queue.enqueue(q, :a)
    q2 = Queue.enqueue(q1, :b)
    assert Queue.to_list(q2) == [:a, :b]

    q3 = Queue.dequeue(q2)
    assert Queue.to_list(q3) == [:b]
  end

  test "head and tail" do
    q = Queue.from_list([:x, :y, :z])
    assert Queue.head(q) == :x
    assert Queue.tail(q) == :z
  end

  test "queue convert to list" do
    list = [:a, :b, :c]
    q = Queue.from_list(list)
    assert Queue.to_list(q) == list
  end

  test "reverse and length" do
    q = Queue.from_list([1, 2, 3])
    reversed = Queue.reverse(q)
    assert Queue.to_list(reversed) == [3, 2, 1]
    assert Queue.length(q) == 3
  end
end
