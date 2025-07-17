defmodule RAL do
  defmodule Tree do
    defstruct [:size, :value, :left, :right]
  end

  def empty([]), do: true
  def empty(_), do: false

  def cons(x, []), do: [%Tree{size: 1, value: x, left: nil, right: nil}]
  def cons(x, [%Tree{size: 1} = t | rest]) do
    new_tree = %Tree{
      size: 2,
      value: x,
      left: %Tree{size: 1, value: x, left: nil, right: nil},
      right: t
    }
    merge(new_tree, rest)
  end
  def cons(x, ral), do: [%Tree{size: 1, value: x, left: nil, right: nil} | ral]

  defp merge(tree, []), do: [tree]
  defp merge(%Tree{size: s1} = t1, [%Tree{size: s2} = t2 | rest]) when s1 == s2 do
    merged = %Tree{
      size: s1 + s2,
      value: t1.value,
      left: t1,
      right: t2
    }
    merge(merged, rest)
  end
  defp merge(tree, ral), do: [tree | ral]

  def head([]), do: raise("Empty RAL")
  def head([%Tree{size: 1, value: v} | _]), do: v
  def head([%Tree{left: %Tree{value: v}} | _]), do: v

  def tail([]), do: raise("Empty RAL")
  def tail([%Tree{size: 1} | rest]), do: rest
  def tail([%Tree{size: _size, left: l, right: r} | rest]) do
    [l, r | rest]
  end

  def lookup(ral, index) do
    case find_tree(ral, index, 0) do
      {offset, tree} -> find_in_tree(tree, build_path(index - offset, tree.size))
      _ -> raise("Index does not exist.")
    end
  end

  defp find_tree([], _i, _acc), do: nil
  defp find_tree([%Tree{size: s} = t | _], i, acc) when i < acc + s, do: {acc, t}
  defp find_tree([%Tree{size: s} | rest], i, acc), do: find_tree(rest, i, acc + s)

  defp build_path(0, _), do: []
  defp build_path(i, size) do
    half = div(size, 2)
    if i < half do
      [0 | build_path(i, half)]
    else
      [1 | build_path(i - half, half)]
    end
  end

  defp find_in_tree(%Tree{value: v}, []), do: v
  defp find_in_tree(%Tree{left: l}, [0 | rest]), do: find_in_tree(l, rest)
  defp find_in_tree(%Tree{right: r}, [1 | rest]), do: find_in_tree(r, rest)

  def update(ral, index, value), do: update_helper(ral, index, value, 0)

  def update_helper([], _index, _value, _acc), do: raise("Index does not exist.")
  def update_helper([%Tree{size: s} = t | rest], index, value, acc) do
    if index < acc + s do
      [replace(t, build_path(index - acc, s), value) | rest]
    else
      [t | update_helper(rest, index, value, acc + s)]
    end
  end

  defp replace(%Tree{left: l, right: r, size: s}, [], val),
    do: %Tree{size: s, value: val, left: l, right: r}
  defp replace(%Tree{left: l, right: r, size: s, value: v}, [0 | rest], val),
    do: %Tree{size: s, value: v, left: replace(l, rest, val), right: r}
  defp replace(%Tree{left: l, right: r, size: s, value: v}, [1 | rest], val),
    do: %Tree{size: s, value: v, left: l, right: replace(r, rest, val)}

  def toList(ral), do: Enum.flat_map(ral, &flatten_tree/1)

  defp flatten_tree(%Tree{left: nil, right: nil, value: v}), do: [v]
  defp flatten_tree(%Tree{left: l, right: r}), do: flatten_tree(l) ++ flatten_tree(r)

  def fromList([]), do: []
  def fromList([h | t]), do: cons(h, fromList(t))
end




ExUnit.start()

defmodule RALTest do
  use ExUnit.Case
  alias RAL

  test "lookup" do
    ral = RAL.fromList([10, 20, 30, 40])
    assert RAL.lookup(ral, 0) == 10
    assert RAL.lookup(ral, 3) == 40
    assert_raise RuntimeError, fn -> RAL.lookup(ral, 4) end
  end

  test "update" do
    ral = RAL.fromList([5, 6, 7])
    updated = RAL.update(ral, 1, 66)
    assert RAL.lookup(updated, 1) == 66
  end
end
