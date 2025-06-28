ExUnit.start()

defmodule FunctionalDeque do
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

defmodule FunctionalDequeTest do
  use ExUnit.Case
  alias FunctionalDeque

  test "empty deque" do
    assert FunctionalDeque.empty(FunctionalDeque.new()) == true
    assert FunctionalDeque.empty({[1], []}) == false
  end

  test "enqueue at rear and front" do
    d = FunctionalDeque.new()
    d = FunctionalDeque.enqueue(d, :a)
    d = FunctionalDeque.enqueue_front(d, :b)
    assert FunctionalDeque.to_list(d) == [:b, :a]
  end

  test "dequeue and dequeue_back from both ends" do
    d = FunctionalDeque.from_list([:x, :y, :z])
    d1 = FunctionalDeque.dequeue(d)
    assert FunctionalDeque.to_list(d1) == [:y, :z]

    d2 = FunctionalDeque.dequeue_back(d)
    assert FunctionalDeque.to_list(d2) == [:x, :y]
  end

  test "head and tail at different states" do
    d = FunctionalDeque.from_list([:a, :b, :c])
    assert FunctionalDeque.head(d) == :a
    assert FunctionalDeque.tail(d) == :c

    d2 = FunctionalDeque.dequeue(d)
    d3 = FunctionalDeque.dequeue_back(d2)
    assert FunctionalDeque.head(d3) == :b
    assert FunctionalDeque.tail(d3) == :b
  end

  test "convert to and from list" do
    list = [:m, :n, :o]
    d = FunctionalDeque.from_list(list)
    assert FunctionalDeque.to_list(d) == list
  end

  test "sequential mixed operations" do
    d = FunctionalDeque.new()
    d = FunctionalDeque.enqueue(d, 1)
    d = FunctionalDeque.enqueue(d, 2)
    d = FunctionalDeque.enqueue_front(d, 0)
    d = FunctionalDeque.dequeue_back(d)
    d = FunctionalDeque.enqueue(d, 3)
    assert FunctionalDeque.to_list(d) == [0, 1, 3]
  end
end
