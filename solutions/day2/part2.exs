#! /usr/bin/env elixir

defmodule Submarine do
  defstruct horizontal_position: 0, depth: 0, aim: 0

  def forward(submarine, amount) do
    %{
      submarine
      | horizontal_position: submarine.horizontal_position + amount,
        depth: submarine.depth + submarine.aim * amount
    }
  end

  def up(submarine, amount) do
    %{submarine | aim: submarine.aim - amount}
  end

  def down(submarine, amount) do
    %{submarine | aim: submarine.aim + amount}
  end
end

defmodule Day2Part1 do
  def solve() do
    File.read!("#{Path.dirname(__ENV__.file)}/input.txt")
    |> String.trim()
    |> String.splitter("\n")
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(fn [instruction, amount] -> [instruction, String.to_integer(amount)] end)
    |> Enum.reduce(%Submarine{}, fn
      ["forward", amount], submarine -> Submarine.forward(submarine, amount)
      ["up", amount], submarine -> Submarine.up(submarine, amount)
      ["down", amount], submarine -> Submarine.down(submarine, amount)
    end)
    |> (&(&1.horizontal_position * &1.depth)).()
    |> IO.puts()
  end
end

Day2Part1.solve()
