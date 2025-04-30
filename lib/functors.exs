#   What is a Functor?
#   A Functor is a pattern that lets you apply a function to data inside a structure like a list or a tree without changing the structure itself. It preserves the relationships between the elements and transforms the values inside.

#   Three Rules:
# 1. Identity Rule: If you pass an identity function, a function that returns its input unchanged, to the functor, the data must stay the same.
# 2. Composition Rule: Applying or mapping two functions one after another inside the functor must yield the same result as applying or mapping the composed function once.
# 3. Structure Preservation Rule: The relationships between the elements must not change after mapping. The order of the elements in the data structure must not change after. The structure of the data structure must not change either, if it starts as a list it must end as a list.

#   Exhaustive Example:
#   We start with a list of phone numbers as strings and apply a sequence of transformations while preserving the structure of the data. First, we apply a validation function that marks numbers as valid or invalid but does not remove any entries. Then, we apply a formatting function to each valid number to make it human-readable by adding parentheses, spaces, and hyphens. This transformation is done using map, which applies the Functor pattern by lifting functions that operate on individual values to the entire list without changing the list itself. The Functor ensures that the relationship between elements and the container remains intact while allowing the internal data to evolve according to the mapping functions.

#   Exhaustive Purpose of Functor:
#   In programming, the Functor pattern describes a design where you have a container or data structure like a list, or dictionary, and you apply a function to the values inside the container without changing the container's structure. It preserves structure, meaning it respects the identity law, or mapping over a value with an identity function results in no change. It also respects the composition law, if you compose two functions and then map, it’s the same as mapping one after the other. A Functor lets you apply a function to a value that's inside something like a list or an option, without taking it out first.






defmodule DictFunctor do
  def map(dict, func) do
    dict
    |> Enum.map(fn {key, value} -> {key, func.(value)} end)
    |> Enum.into(%{})
  end
end


my_dict = %{"a" => 1, "b" => 2, "c" => 3}
new_dict = DictFunctor.map(my_dict, fn v -> v * 10 end)
IO.inspect(new_dict)
