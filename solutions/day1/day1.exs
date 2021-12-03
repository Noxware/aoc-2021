#! /usr/bin/env elixir

defmodule Day1 do
  @this_file_folder Path.dirname(__ENV__.file)

  def solve_part_1() do
    File.stream!("#{@this_file_folder}/input.txt")
    |> Stream.filter(&(&1 != ""))
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.scan(%{}, fn e, acc -> %{previous: acc[:current], current: e} end)
    |> Stream.drop(1)
    |> Enum.reduce(0, fn e, acc -> if e[:previous] < e[:current], do: acc + 1, else: acc end)
    |> IO.puts()
  end

  def solve_part_2() do
    chunk_fun = fn
      e, acc = [i1, i2, _i3] -> {:cont, Enum.sum(acc), [e, i1, i2]}
      e, acc -> {:cont, [e | acc]}
    end

    after_fun = fn
      acc -> {:cont, Enum.sum(acc), nil}
    end

    File.stream!("#{@this_file_folder}/input.txt")
    |> Stream.filter(&(&1 != ""))
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    # Difference from part 1
    |> Stream.chunk_while([], chunk_fun, after_fun)
    # Continue like part 1
    |> Stream.scan(%{}, fn e, acc -> %{previous: acc[:current], current: e} end)
    |> Stream.drop(1)
    |> Enum.reduce(0, fn e, acc -> if e[:previous] < e[:current], do: acc + 1, else: acc end)
    |> IO.puts()
  end
end

Day1.solve_part_1()
Day1.solve_part_2()
