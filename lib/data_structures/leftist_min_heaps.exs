ExUnit.start()

defmodule LeftistMinHeap do
  def new(), do: nil

  def empty(nil), do: true
  def empty(_), do: false

  defp rank(nil), do: 0
  defp rank({r, _, _, _}), do: r

  defp make_node(value, a, b) do
    if rank(a) >= rank(b) do
      {rank(b) + 1, value, a, b}
    else
      {rank(a) + 1, value, b, a}
    end
  end

  def merge(nil, h), do: h
  def merge(h, nil), do: h
  def merge({_, v1, l1, r1} = h1, {_, v2, l2, r2} = h2) do
    if v1 <= v2 do
      make_node(v1, l1, merge(r1, h2))
    else
      make_node(v2, l2, merge(h1, r2))
    end
  end

  def insert(h, value), do: merge({1, value, nil, nil}, h)

  def findMin(nil), do: nil
  def findMin({_, value, _, _}), do: value

  def deleteMin(nil), do: nil
  def deleteMin({_, _, left, right}), do: merge(left, right)

  def toList(nil), do: []
  def toList(h), do: [findMin(h) | toList(deleteMin(h))]

  def fromList(list), do: Enum.reduce(list, new(), fn e, acc -> insert(acc, e) end)
end



defmodule LeftistMinHeapTest do
  use ExUnit.Case
  alias LeftistMinHeap

  test "empty heap checks" do
    assert LeftistMinHeap.empty(LeftistMinHeap.new()) == true
    assert LeftistMinHeap.empty({1, 5, nil, nil}) == false
  end

  test "insert and findMin" do
    h = LeftistMinHeap.new()
    h = LeftistMinHeap.insert(h, 10)
    h = LeftistMinHeap.insert(h, 3)
    h = LeftistMinHeap.insert(h, 7)
    assert LeftistMinHeap.findMin(h) == 3
  end

  test "deleteMin from non-empty and empty heap" do
    h = LeftistMinHeap.fromList([8, 4, 5])
    assert LeftistMinHeap.findMin(h) == 4
    h = LeftistMinHeap.deleteMin(h)
    assert LeftistMinHeap.findMin(h) == 5

    h2 = LeftistMinHeap.deleteMin(LeftistMinHeap.new())
    assert h2 == nil
  end

  test "merge two heaps" do
    h1 = LeftistMinHeap.fromList([1, 4, 6])
    h2 = LeftistMinHeap.fromList([2, 3, 5])
    merged = LeftistMinHeap.merge(h1, h2)
    assert LeftistMinHeap.toList(merged) == Enum.sort([1, 2, 3, 4, 5, 6])
  end

  test "toList returns sorted order" do
    h = LeftistMinHeap.fromList([9, 3, 7, 1, 5])
    assert LeftistMinHeap.toList(h) == [1, 3, 5, 7, 9]
  end
end
