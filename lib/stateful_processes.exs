# Stateless Processes:

# Definition:
# Allows processes to maintain and update their own internal state. Data persists across multiple calls.
# They process messages that are received and then calls itself recursively with the updated state information.
# Each process runs in a single thread, so it handles one message at a time, preventing race conditions.
# Each process is isolated and communicates with other processes using message passing,
# state changes are controlled and explicit.

# Real-World Example:
# Let's say we are building a chat app where we need to keep track of users being online or offline.
# Using a dedicated database wouldn't be very fast. We should instead use a stateful process.
# This will allow us to keep track of an individual user's state inside of memory.
# The process would receive a message to login with the user id,
# and the process would send back a message saying they have logged in.
# To check status the program would send a message asking the process if user_id is logged in,
# The process will return the current state of the user which would be logged in.

# Practical Examples:
# Stateful processes are practical in a lot of scenarios.
# One example is in web applications we can use a stateful process to manage a single user's web session state,
# and each session is a seperate process.
# They are particularly useful for managing state over time, and are highly concurrent and fault tolerant.

# Downsides/Mitigation:
# If a process were to crash unexpectadly, we could lose the state that the process was holding.
# We also run into memory issues if we use a lot of processes at once.
# To mitigate these we can optimize our programs and keep track of how much memory is being used.
# In case of crash we could periodically save state to a file or database,
# we could also have functions in place to recover the state in case of a crash.

# Supervision Strategies:
# :one_for_one, :one_for_all
# Supervision trees allow us to monitor worker processes, and if a process crashes,
# it can automatically restart that process.
# Since each process is isolated it won't affect other processes if one were to crash.

# When not to use:
# When we don't need to manage state at all, there is no point in complicating our program to do this.
# If we don't need to manage state for a very long time it might be better to use asynchronous operations.
# We should use pure functions if we don't need to store state.
# If we need to store a state managed by multiple processes it would be better to use a database.

# Code - elixir stateful_processes.exs

defmodule Counter do
  def start(initial_count) do
    spawn(fn -> loop(initial_count) end)
  end

  defp loop(count) do
    receive do
      {:increment, caller} ->
        new_count = count + 1
        send(caller, {:ok, new_count})
        loop(new_count)

      {:decrement, caller} ->
        new_count = count - 1
        send(caller, {:ok, new_count})
        loop(new_count)

      {:get, caller} ->
        send(caller, {:ok, count})
        loop(count)
    end
  end
end

# Tests

pid = Counter.start(0)

send(pid, {:increment, self()})
receive do {:ok, count} -> IO.puts("New Count: #{count}") end
send(pid, {:increment, self()})
receive do {:ok, count} -> IO.puts("New Count: #{count}") end

send(pid, {:get, self()})
receive do {:ok, count} -> IO.puts("Current Count: #{count}") end
