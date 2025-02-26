# Variables, Tuples, Lists, List BIFs/Elixir Basics:

# There are no multi line comments, easily. Just use multiple #s.

# .puts will print something to the console quickly. Inspect will show what a variable is stored as.
# puts is shorthand for "put string."
IO.puts("Hello, World!")

# Code - elixir variables_tuples_lists.exs

# VARIABLES:

# Variables are immutable in Elixir. Variables are just labels that point to values in Elixir.
# Rebinding: Instead of reassigning then we take a variable and rebind it to a new value.
# No type declaration.
# When a variable is changed it creates a new instance of that variable. It keeps the old one until it is not
# referenced again and is picked up by Elixir's garbage collector.
# Elixir uses the "=" operator to pattern match instead of traditional assignment. This is used for structure not only convienence.
name = "Connor"
age = 21
x = 2.6
x_rounded = Float.round(x)
IO.inspect(x)
IO.inspect(x_rounded)
IO.inspect(name)
IO.inspect(age)

# TUPLES:

# WORKING RESPONSE:
# Tuples are fixed length, small data structures that are used in Elixir to store a series of values.
# They can be used to access values or return values from functions. In Elixir they can store any number of
# values as we want, but are best for small numbers of values. They are much faster than lists when it comes
# to accessing data, but they cannot be added/removed from. If we wish to add a value to a tuple, Elixir creates
# a whole new tuple with the new values. This makes it much slower than lists if we need to create more tuples.
# We use tuples when we need to create a small data structure that stores unchanging information. An example of a
# tuple in the real world could be storing user information like Name, birthdate, and Social Security Number, and
# other information that will never change.
person_tuple = {"Connor", 21, "Software Developer"}
IO.inspect(person_tuple)

{first, second, third} = {1,4,9}
IO.inspect(second)

rec_tuple = {2,4}
area = elem(rec_tuple, 0) * elem(rec_tuple, 1)
IO.inspect(area)


# LISTS/BIFs:

# Lists can be added or removed to. Whenever a new element is added or removed it will create a new list.
# Lists are much more efficient when it comes to adding/removing.

# reduce/3
num_list = [2, 5, 21, 5]
sum = Enum.reduce(num_list, 0, fn x, index -> x + index end)
IO.puts("Sum:")
IO.inspect(sum)







num_list_2 = [1,2]
{head, tail} = {Enum.at(num_list_2, 0), Enum.at(num_list_2, 1)}
sum = Enum.at(num_list, 0) + Enum.at(num_list, 1)
IO.inspect(sum)

squared_list = Enum.map(num_list, fn a -> a*a end)
IO.inspect(squared_list)

atom_list = [:start, :end]
IO.inspect(atom_list)
atom_list = [:new | atom_list]
IO.inspect(atom_list)
IO.inspect(Enum.member?(atom_list, :start))

# The list structure is separated into two areas, the head(first element) and the tail(all remaining elements)
IO.inspect(num_list)
# Adding to a list( | ), creates a new list and GC will get rid of the old one once all references to it are gone.
num_list = [1 | num_list]
IO.inspect(num_list)
# Concat lists(++). Joins but creates a new list:
second_list = [9, 9, 10]
combined_list = num_list ++ second_list
IO.inspect(combined_list)
# Removing from a list(-- [x]). Removes but creates a new list.
# Removes the first occurence of the element.
num_list = num_list -- [5]
IO.inspect(num_list)
# Checking Membership(x in [list])
IO.puts(21 in num_list)  # true
IO.puts(3 in num_list)  # false
# Length(length([list]))
IO.inspect(num_list)
IO.puts(length(num_list))
# hd/tl Extraction. hd returns leading var, tl returns list of remaining elements.
IO.inspect(hd(num_list))
IO.inspect(tl(num_list))
