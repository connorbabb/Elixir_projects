defmodule Bank do
  def start(initial_balance \\ 0) do
    state = %{balance: initial_balance}
    spawn(fn -> loop(state) end)
  end

  defp loop(state) do
    receive do
      {:deposit, amount, sender} when amount > 0 ->
        new_state = %{state | balance: state.balance + amount}
        send(sender, {:ok, new_state.balance})
        loop(new_state)

      {:withdraw, amount, sender} when amount > 0 and amount <= state.balance ->
        new_state = %{state | balance: state.balance - amount}
        send(sender, {:ok, new_state.balance})
        loop(new_state)
      {:withdraw, amount, sender} when amount > state.balance ->
        send(sender, {:error, :insufficient_funds_in_account})
        loop(state)

      {:balance, sender} ->
        send(sender, {:ok, state.balance})
        loop(state)

      :stop ->
        :ok
    end
  end
end

# pid = Bank.start(100)
# send(pid, {:deposit, 50, self()})
# flush()
# {:ok, 150}

# send(pid, {:withdraw, 25, self()})
# flush()
# {:ok, 125}

# send(pid, {:balance, self()})
# flush()
# {:ok, 125}

# send(pid, {:withdraw, 200, self()})
# flush()
# {:error, :insufficient_funds_in_account}

# send(pid, :stop)
