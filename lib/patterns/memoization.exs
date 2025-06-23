defmodule RevenueMemo do
  def start_link do
    spawn_link(fn -> loop(%{}) end)
  end

  defp loop(cache) do
    receive do
      {:calculate_total, sender, sales_data} ->
        key = {:calculate_total, sales_data}

        case Map.get(cache, key) do
          nil ->
            total = Enum.sum(sales_data)
            send(sender, {:result, total})
            IO.puts("")
            IO.puts("Value added to Cache.")
            loop(Map.put(cache, key, total))

          cached_total ->
            send(sender, {:result, cached_total})
            IO.puts("")
            IO.puts("Pulling from Cache")
            loop(cache)
        end

      :stop ->
        :ok
    end
  end
end

# Start the thing
# Results
pid = RevenueMemo.start_link()

send(pid, {:calculate_total, self(), [100, 200, 300]})
receive do
  {:result, total} -> IO.puts("Received total: #{total}")
end

send(pid, {:calculate_total, self(), [100, 200, 300]})
receive do
  {:result, total} -> IO.puts("Received total: #{total}")
end

send(pid, {:calculate_total, self(), [50, 50, 100]})
receive do
  {:result, total} -> IO.puts("Received total: #{total}")
end
