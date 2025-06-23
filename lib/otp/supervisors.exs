defmodule LifecycleChild do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  @impl true
  def init(name) do
    IO.puts("[#{name}] Starting")
    {:ok, name}
  end

  @impl true
  def terminate(_reason, name) do
    IO.puts("[#{name}] Terminating cleanly")
    :ok
  end
end

defmodule LifecycleSupervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      %{
        id: :child1,
        start: {LifecycleChild, :start_link, [:Connor_Babb]},
        shutdown: 1000
      },
      %{
        id: :child2,
        start: {LifecycleChild, :start_link, [:Brother_Barney]},
        shutdown: 1000
      },
      %{
        id: :child3,
        start: {LifecycleChild, :start_link, [:Billy]},
        shutdown: 1000
      }
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end

{:ok, sup} = LifecycleSupervisor.start_link()
:timer.sleep(1000)
# Both children statting.

Process.exit(sup, :shutdown)
:timer.sleep(1000)
# Both children TERMINATED (cleanly).
