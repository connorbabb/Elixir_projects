ExUnit.start()

defmodule Deque do
  def new(), do: {[], []}

  def empty({[], []}), do: true
  def empty(_), do: false

  def enqueue({front, rear}, element), do: {front, [element | rear]}
  def enqueue_front({front, rear}, element), do: {[element | front], rear}

  def dequeue({[], []}), do: {[], []}
  def dequeue({[], rear}), do: dequeue({Enum.reverse(rear), []})
  def dequeue({[_h | t], rear}), do: {t, rear}

  def dequeue_back({[], []}), do: {[], []}
  def dequeue_back({front, []}), do: {Enum.reverse(tl(Enum.reverse(front))), []}
  def dequeue_back({front, [_h | t]}), do: {front, t}

  def head({[], []}), do: nil
  def head({[], rear}), do: List.last(rear)
  def head({[h | _], _}), do: h

  def tail({[], []}), do: nil
  def tail({front, []}), do: List.last(front)
  def tail({_, [h | _]}), do: h

  def to_list({front, rear}), do: front ++ Enum.reverse(rear)

  def from_list(list), do: {list, []}
end

defmodule DequeTest do
  use ExUnit.Case
  alias Deque

  test "Enqueue to rear and front" do
    d = Deque.new()
    d = Deque.enqueue(d, :a)
    d = Deque.enqueue_front(d, :b)
    assert Deque.to_list(d) == [:b, :a]
  end

  test "Dequeue and dequeue_back" do
    d = Deque.from_list([:x, :y, :z])
    d1 = Deque.dequeue(d)
    assert Deque.to_list(d1) == [:y, :z]

    d2 = Deque.dequeue_back(d)
    assert Deque.to_list(d2) == [:x, :y]
  end

  test "Accessing head and tail" do
    d = Deque.from_list([:a, :b, :c])
    assert Deque.head(d) == :a
    assert Deque.tail(d) == :c

    d2 = Deque.dequeue(d)
    d3 = Deque.dequeue_back(d2)
    assert Deque.head(d3) == :b
    assert Deque.tail(d3) == :b
  end

  test "Convert between list and Deque" do
    list = [:m, :n, :o]
    d = Deque.from_list(list)
    assert Deque.to_list(d) == list
  end

  test "Combining multiple operations" do
    d = Deque.new()
    d = Deque.enqueue(d, 1)
    d = Deque.enqueue(d, 2)
    d = Deque.enqueue_front(d, 0)
    d = Deque.dequeue_back(d)
    d = Deque.enqueue(d, 3)
    assert Deque.to_list(d) == [0, 1, 3]
  end
end
