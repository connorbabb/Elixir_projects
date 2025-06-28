ExUnit.start()

defmodule FunctionalBST do
  def new(), do: nil

  def empty(nil), do: true
  def empty(_), do: false

  def add(nil, element), do: {element, nil, nil}
  def add({v, l, r}, element) when element < v, do: {v, add(l, element), r}
  def add({v, l, r}, element), do: {v, l, add(r, element)}

  def contains(nil, _), do: false
  def contains({v, _, _}, v), do: true
  def contains({v, l, _}, element) when element < v, do: contains(l, element)
  def contains({_, _, r}, element), do: contains(r, element)

  def remove(nil, _), do: nil
  def remove({v, l, r}, v) do
    case {l, r} do
      {nil, nil} -> nil
      {nil, _} -> r
      {_, nil} -> l
      _ ->
        min_r = min(r)
        {min_r, l, remove(r, min_r)}
    end
  end
  def remove({v, l, r}, element) when element < v, do: {v, remove(l, element), r}
  def remove({v, l, r}, element), do: {v, l, remove(r, element)}

  def min(nil), do: nil
  def min({v, nil, _}), do: v
  def min({_, l, _}), do: min(l)

  def max(nil), do: nil
  def max({v, _, nil}), do: v
  def max({_, _, r}), do: max(r)

  def to_list(nil), do: []
  def to_list({v, l, r}), do: to_list(l) ++ [v] ++ to_list(r)

  def from_list(list), do: Enum.reduce(list, new(), fn e, acc -> add(acc, e) end)

  def height(nil), do: 0
  def height({_, l, r}), do: 1 + max(height(l), height(r))

  def is_balanced(nil), do: true
  def is_balanced({_, l, r}) do
    abs(height(l) - height(r)) <= 1 and is_balanced(l) and is_balanced(r)
  end
end

defmodule FunctionalBSTTest do
  use ExUnit.Case
  alias FunctionalBST

  test "empty and new tree" do
    assert FunctionalBST.empty(nil) == true
    assert FunctionalBST.empty({1, nil, nil}) == false
  end

  test "add and contains" do
    t = FunctionalBST.new()
    t = FunctionalBST.add(t, 10)
    t = FunctionalBST.add(t, 5)
    t = FunctionalBST.add(t, 15)

    assert FunctionalBST.contains(t, 10)
    refute FunctionalBST.contains(t, 20)
  end

  test "min and max values" do
    t = FunctionalBST.from_list([10, 5, 15, 3, 7])
    assert FunctionalBST.min(t) == 3
    assert FunctionalBST.max(t) == 15
  end

  test "remove leaf, one-child, and two-child nodes" do
    t = FunctionalBST.from_list([10, 5, 15, 3, 7, 12, 18])
    t = FunctionalBST.remove(t, 3)   # leaf
    refute FunctionalBST.contains(t, 3)

    t = FunctionalBST.remove(t, 5)   # one child
    refute FunctionalBST.contains(t, 5)

    t = FunctionalBST.remove(t, 10)  # two children (root)
    refute FunctionalBST.contains(t, 10)

    assert FunctionalBST.to_list(t) == [7, 12, 15, 18]
  end

  test "convert between list and BST" do
    list = [8, 3, 10, 1, 6, 14]
    tree = FunctionalBST.from_list(list)
    sorted = Enum.sort(list)
    assert FunctionalBST.to_list(tree) == sorted
  end

  test "height and balance check" do
    balanced = FunctionalBST.from_list([10, 5, 15, 3, 7, 13, 17])
    unbalanced = FunctionalBST.from_list([1, 2, 3, 4, 5])

    assert FunctionalBST.height(balanced) == 3
    assert FunctionalBST.height(unbalanced) == 5

    assert FunctionalBST.is_balanced(balanced)
    refute FunctionalBST.is_balanced(unbalanced)
  end
end
