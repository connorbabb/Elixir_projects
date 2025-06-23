defmodule Hotel do
  @behaviour :gen_statem

  ## API
  def start_link(_) do
    :gen_statem.start_link({:local, __MODULE__}, __MODULE__, :vacant, [])
  end

  def check_in, do: :gen_statem.call(__MODULE__, :check_in)
  def check_out, do: :gen_statem.call(__MODULE__, :check_out)
  def housekeeping_start, do: :gen_statem.call(__MODULE__, :housekeeping_start)
  def housekeeping_done, do: :gen_statem.call(__MODULE__, :housekeeping_done)

  ## Required callback to initialize
  @impl true
  def init(initial_state) do
    {:ok, initial_state, %{}}
  end

  ## Required callback declaration
  @impl true
  def callback_mode, do: :handle_event_function

  ## State transition logic
  @impl true
  def handle_event({:call, from}, :check_in, :vacant, data) do
    {:next_state, :occupied, data, [{:reply, from, :ok}]}
  end

  # RULE: No check in during cleaning:^^
  def handle_event({:call, from}, :check_in, :cleaning, _data) do
    {:keep_state_and_data, [{:reply, from, {:error, :room_being_cleaned}}]}
  end

  def handle_event({:call, from}, :check_out, :occupied, data) do
    {:next_state, :vacant, data, [{:reply, from, :ok}]}
  end

  def handle_event({:call, from}, :housekeeping_start, :vacant, data) do
    {:next_state, :cleaning, data, [{:reply, from, :ok}]}
  end

  def handle_event({:call, from}, :housekeeping_done, :cleaning, data) do
    {:next_state, :vacant, data, [{:reply, from, :ok}]}
  end

  # Catch all event:
  def handle_event({:call, from}, event, state, _data) do
    {:keep_state_and_data, [{:reply, from, {:error, {:invalid_event, event, state}}}]}
  end
end


{:ok, _pid} = Hotel.start_link([])
IO.inspect(Hotel.check_in())
IO.inspect(Hotel.check_in()) # error: already occupied room.
IO.inspect(Hotel.housekeeping_start()) # error since occupied.
IO.inspect(Hotel.check_out())
IO.inspect(Hotel.housekeeping_start())
IO.inspect(Hotel.check_in())  # error since room is still being cleaned.
IO.inspect(Hotel.housekeeping_done())
