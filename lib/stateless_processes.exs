# Stateless Processes:

# Definition:
# A lightweight process that doesn't maintain internal state between messages.
# When a stateless process receives a message it performs the function and then discards any data that was used.
# Each request is handeled independantly. ONLY input determines behavior, since no state beforehand is given.
# Often used for pure computations, or message passing.
# Remember that they are not related to system processes, they are used for concurrency and are fast and fault tolerant.

# Real-World Example:
# Lets say we want to log messages to a file concurrently, meaning we log the message using a process,
# but the main loop or program will concurrently run alongside the logging process since requests to log can take time.
# This ensures that we are still running our main program while our request to log to the file is being completed.
# The process is started when we create a PID by spawning a process in a function.
# When the process is started it waits to receive a message with an identifier that allows it to log the message.
# We use the 'send' built in function passing it the PID, which is a unique identifier,
# and the message that we want to have the process receive.
# Once the function is completed, the process will die and not keep any state or data.

# Usefullness:
# stateless processes are incredibly useful in Elixir for a few reasons. Stateless processes are
# extremely lightweight, even compared to threads in other languages. They allow programs to run different
# sections of code concurrently or side by side. For example, since some functions take time to complete, like
# waiting for an API request, it doesn't make sense for the entire program to wait on that function. So we instead
# create a process to complete that task. Once the task is completed, the process terminates itself, not storing
# any data or keeping any state, so we don't have to worry about unused data in memory. Processes can be helpful
# to make programs concurrent or parallel, resulting in faster or more efficient programs.

# Code - elixir stateless_processes.exs

defmodule Echo do
   def start do
      spawn(fn -> loop() end)
   end

   def loop do
      receive do
         message ->
            IO.puts("Received: #{inspect(message)}")
      end

      loop()
   end
end


defmodule LoggerProcess do
  def start do
    spawn(fn -> loop() end)
  end

   defp loop do
     receive do
      {:log, message} ->
         File.write!("log.txt", "#{message}\n", [:append])
     end

     loop()
  end
end


defmodule StringReplacer do
   def replace_character do
     receive do
       {caller, string, target, replacement} ->
         new_string = String.replace(string, target, replacement)
         send(caller, {:ok, new_string})
     end
   end
 end

 defmodule ListConcatenator do
  def concat_lists do
    receive do
      {caller, lists} ->
        result = Enum.concat(lists)
        send(caller, {:ok, result})
    end
  end
end

defmodule ComputePower do
  def power_number do
    receive do
      {caller, num, pow} ->
        powered_num = :math.pow(num, pow)
        send(caller, {:ok, powered_num})
    end
  end
end

# Example Usage
pid = spawn(ListConcatenator, :concat_lists, [])
send(pid, {self(), [[1, 2, 3], [4, 5], [6, 7, 8]]})

receive do
  {:ok, result} -> IO.inspect(result, label: "Concatenated List")
end


 pid = Echo.start()
 send(pid, "Hello, Elixir!")
 send(pid, "First message!")
 send(pid, "Second message!")
 send(pid, "Third message!")

 # Example Usage
 pid = spawn(StringReplacer, :replace_character, [])
 send(pid, {self(), "hello world", "o", "0"})

 receive do
   {:ok, result} -> IO.puts("Updated String: #{result}")
 end

# Start the process
# logger_pid = LoggerProcess.start()

# Send messages to be logged
# send(logger_pid, {:log, "User signed in"})
# send(logger_pid, {:log, "Payment processed"})
# send(logger_pid, {:log, "Error: Invalid password"})

# Give it time to process
Process.sleep(500)
