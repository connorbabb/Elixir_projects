ExUnit.start()

defmodule Trie do
  @end_marker :end

  def new(), do: %{}

  def empty(trie), do: map_size(trie) == 0

  def add(trie, []), do: Map.put(trie, @end_marker, true)
  def add(trie, [h | t]) do
    subtrie = Map.get(trie, h, %{})
    Map.put(trie, h, add(subtrie, t))
  end

  def contains(trie, []), do: Map.has_key?(trie, @end_marker)
  def contains(trie, [h | t]) do
    case Map.get(trie, h) do
      nil -> false
      subtrie -> contains(subtrie, t)
    end
  end

  def remove(trie, sequence), do: prune(remove_helper(trie, sequence))
  defp remove_helper(trie, []), do: Map.delete(trie, @end_marker)
  defp remove_helper(trie, [h | t]) do
    case Map.get(trie, h) do
      nil -> trie
      subtrie -> Map.put(trie, h, remove_helper(subtrie, t))
    end
  end

  defp prune(trie) do
    Enum.reduce(trie, %{}, fn
      {@end_marker, true}, acc -> Map.put(acc, @end_marker, true)
      {k, v}, acc ->
        pruned = prune(v)
        if pruned == %{}, do: acc, else: Map.put(acc, k, pruned)
    end)
  end

  def prefix(trie, prefix), do: prefix_search(trie, prefix, [])
  defp prefix_search(trie, [], path), do: collect(trie, path)
  defp prefix_search(trie, [h | t], path) do
    case Map.get(trie, h) do
      nil -> []
      subtrie -> prefix_search(subtrie, t, path ++ [h])
    end
  end

  def to_list(trie), do: collect(trie, [])

  def from_list(list), do: Enum.reduce(list, new(), fn seq, acc -> add(acc, seq) end)

  defp collect(trie, path) do
    Enum.flat_map(trie, fn
      {@end_marker, true} -> [path]
      {k, v} -> collect(v, path ++ [k])
    end)
  end
end





defmodule TrieTest do
  use ExUnit.Case
  alias Trie

  test "add and contains" do
    trie = Trie.new()
    trie = Trie.add(trie, [:a, :b, :c])
    assert Trie.contains(trie, [:a, :b, :c])
    refute Trie.contains(trie, [:a, :b])
  end

  test "remove sequences with overlap" do
    trie = Trie.from_list([[:a, :b], [:a, :b, :c]])
    trie = Trie.remove(trie, [:a, :b])
    refute Trie.contains(trie, [:a, :b])
    assert Trie.contains(trie, [:a, :b, :c])
  end

  test "add duplicate sequences" do
    trie = Trie.from_list([[:x, :y], [:x, :y]])
    assert Trie.to_list(trie) == [[:x, :y]]
  end

  test "prefix search" do
    trie = Trie.from_list([[:c, :a, :t], [:c, :a, :r], [:c, :a, :r, :t], [:d, :o, :g]])
    matches = Trie.prefix(trie, [:c, :a])
    assert Enum.sort(matches) == [[:c, :a, :r], [:c, :a, :r, :t], [:c, :a, :t]]
  end

  test "handling empty sequences" do
    trie = Trie.add(Trie.new(), [])
    assert Trie.contains(trie, [])
    trie = Trie.remove(trie, [])
    refute Trie.contains(trie, [])
  end
end
