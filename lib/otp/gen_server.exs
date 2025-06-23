defmodule TemperatureServer do
  use GenServer

  # API

  def start_link(safe_range) do
    GenServer.start_link(__MODULE__, %{temps: [], safe_range: safe_range}, name: __MODULE__)
  end

  def add_temp(temp) do
    GenServer.cast(__MODULE__, {:add_temp, temp})
  end

  def average_temperature() do
    GenServer.call(__MODULE__, :get_avg)
  end

  # GenServer Callbacks

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:add_temp, temp}, state) do
    {min, max} = state.safe_range

    cond do
      temp < min - 20 ->
        IO.puts("#{temp} is waaaaaay too COLD!")
      temp < min ->
        IO.puts("#{temp} is too COLD!")
      temp > max + 20 ->
        IO.puts("#{temp} is waaaaaay too HOT!")
      temp > max ->
        IO.puts("#{temp} is too HOT!")
      true ->
        IO.puts("#{temp} is safe.")
        :ok
    end
    {:noreply, %{state | temps: [temp | state.temps]}}
  end

  @impl true
  def handle_call(:get_avg, _from, state) do
    avg =
      case state.temps do
        [] -> :no_data
        temps -> Enum.sum(temps) / length(temps)
      end

    {:reply, avg, state}
  end
end

{:ok, _pid} = TemperatureServer.start_link({50, 80})
TemperatureServer.add_temp(-20)
TemperatureServer.add_temp(42)
TemperatureServer.add_temp(65)
TemperatureServer.add_temp(85)
TemperatureServer.add_temp(110)
IO.puts("Average: #{TemperatureServer.average_temperature()}")
