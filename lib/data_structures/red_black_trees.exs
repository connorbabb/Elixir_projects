ExUnit.start()

defmodule RBT do
  @red :red
  @black :black

  def new(), do: nil

  def isEmpty(nil), do: true
  def isEmpty(_), do: false

  def contains(nil, _), do: false
  def contains({_, v, _, _}, v), do: true
  def contains({_, v, l, _}, x) when x < v, do: contains(l, x)
  def contains({_, _, _, r}, x), do: contains(r, x)

  def add(tree, x) do
    {_, v, l, r} = insert(tree, x)
    {@black, v, l, r}
  end

  defp insert(nil, x), do: {@red, x, nil, nil}
  defp insert({color, v, l, r}, x) when x < v do
    balance({color, v, insert(l, x), r})
  end
  defp insert({color, v, l, r}, x) when x > v do
    balance({color, v, l, insert(r, x)})
  end
  defp insert(node, _), do: node

  defp balance({@black, z, {@red, y, {@red, x, a, b}, c}, d}),
    do: {@red, y, {@black, x, a, b}, {@black, z, c, d}}
  defp balance({@black, z, {@red, x, a, {@red, y, b, c}}, d}),
    do: {@red, y, {@black, x, a, b}, {@black, z, c, d}}
  defp balance({@black, x, a, {@red, z, {@red, y, b, c}, d}}),
    do: {@red, y, {@black, x, a, b}, {@black, z, c, d}}
  defp balance({@black, x, a, {@red, y, b, {@red, z, c, d}}}),
    do: {@red, y, {@black, x, a, b}, {@black, z, c, d}}
  defp balance(node), do: node

  def min(nil), do: nil
  def min({_, v, nil, _}), do: v
  def min({_, _, l, _}), do: min(l)

  def max(nil), do: nil
  def max({_, v, _, nil}), do: v
  def max({_, _, _, r}), do: max(r)

  def toList(nil), do: []
  def toList({_, v, l, r}), do: toList(l) ++ [v] ++ toList(r)

  def fromList(list), do: Enum.reduce(list, new(), fn x, acc -> add(acc, x) end)

  def remove(tree, _x), do: tree
end

defmodule RBTTest do
  use ExUnit.Case
  alias RBT

  test "empty and contains" do
    assert RBT.isEmpty(nil)
    refute RBT.isEmpty(RBT.add(nil, 10))

    tree = RBT.add(nil, 10)
    assert RBT.contains(tree, 10)
    refute RBT.contains(tree, 5)
  end

  test "min and max" do
    tree = RBT.fromList([10, 5, 20, 3])
    assert RBT.min(tree) == 3
    assert RBT.max(tree) == 20
  end

  test "toList returns sorted elements" do
    tree = RBT.fromList([7, 2, 9, 1, 5])
    assert RBT.toList(tree) == [1, 2, 5, 7, 9]
  end

  test "add duplicates has no effect" do
    tree = RBT.fromList([5, 3, 7, 3])
    assert RBT.toList(tree) == [3, 5, 7]
  end

  test "remove is a no-op placeholder" do
    tree = RBT.fromList([8, 3, 10])
    new_tree = RBT.remove(tree, 3)
    assert RBT.toList(new_tree) == [3, 8, 10]
  end
end
