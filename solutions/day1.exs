defmodule Day1 do
  def solve_part_1() do
    File.read!("assets/day1_input.txt")
    |> String.trim()
    |> String.splitter("\n")
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

    File.read!("assets/day1_input.txt")
    |> String.trim()
    |> String.splitter("\n")
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
