# File can be ran by typing "mix" in cmd prompt. Check mix.exs and tutorial for that for how this works.

defmodule Project do
  use Application

  # @ is a module attribute, like saying const in JS, it cannot change.
  @x 5

  # args describes data passsed to the parameter,
  # but we are not passing any data so we use _'s to say we won't use them,
  # so elixir doesn't freak out at unused variables.
  def start(_type, _args) do
    Project.main()
    Supervisor.start_link([], strategy: :one_for_one)  # Supervisor is a process, that supervises other processes.
  end

  def main do
    IO.puts(@x)
    # Using atoms will usually reduce memory usage.
    IO.puts(:"hello world")

    name = "Caleb"
    status = Enum.random([:gold, :silver, :bronze, :"not a member"])

    # Triple === will perform STRICT type checking for equality, so 1.0 does NOT equal 1. With == 1.0 would = 1.
    if status === :gold do
      IO.puts("Welcome to the fancy lounge, #{name}")
    else
      IO.puts("Get lost")
    end
    # Use if statements for simple true false checks with not many paths. Use case for checking against multiple possible values.
    case status do
      :gold -> IO.puts("Welcome to the fancy loung, #{name}")
      :"not a member" -> IO.puts("Get subscribed")
      _ -> IO.puts("Get out bruh")
    end
  end
end
