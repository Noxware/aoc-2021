#! /usr/bin/env elixir

defmodule BitCounter do
  defstruct zeros: 0, ones: 0

  defp increment_zeros(counter) do
    %{counter | zeros: counter.zeros + 1}
  end

  defp increment_ones(counter) do
    %{counter | ones: counter.ones + 1}
  end

  def most_common(counter, fallback) do
    cond do
      counter.zeros > counter.ones -> "0"
      counter.ones > counter.zeros -> "1"
      true -> fallback
    end
  end

  def least_common(counter, fallback) do
    cond do
      counter.zeros < counter.ones -> "0"
      counter.ones < counter.zeros -> "1"
      true -> fallback
    end
  end

  def from_rows_of_bits(rows) do
    bits_per_row = rows |> Enum.at(0) |> length()

    bit_counters = List.duplicate(%BitCounter{}, bits_per_row)

    rows
    |> Enum.reduce(bit_counters, fn graphemes, acc ->
      Stream.zip(graphemes, acc)
      |> Stream.map(fn
        {"0", counter} -> increment_zeros(counter)
        {"1", counter} -> increment_ones(counter)
      end)
      |> Enum.to_list()
    end)
  end
end

defmodule Day3Part2 do
  def solve() do
    rows_of_bits =
      File.read!("#{Path.dirname(__ENV__.file)}/input.txt")
      |> String.trim()
      |> String.splitter("\n")
      |> Stream.map(&String.graphemes/1)
      |> Enum.to_list()

    oxygen_generator_rating =
      filter_bit_rows(rows_of_bits, 0, &BitCounter.most_common(&1, "1"))
      |> Enum.join()
      |> String.to_integer(2)

    co2_scrubber_rating =
      filter_bit_rows(rows_of_bits, 0, &BitCounter.least_common(&1, "0"))
      |> Enum.join()
      |> String.to_integer(2)

    IO.puts(oxygen_generator_rating * co2_scrubber_rating)
  end

  defp filter_bit_rows([row], _bit_position, _common_fun) do
    row
  end

  defp filter_bit_rows(rows_of_bits, bit_position, common_fun) do
    bit_counters = BitCounter.from_rows_of_bits(rows_of_bits)

    bit_value =
      bit_counters
      |> Enum.at(bit_position)
      |> (fn e ->
            IO.inspect(rows_of_bits)
            e
          end).()
      |> common_fun.()

    rows_of_bits
    |> Enum.filter(fn bits -> Enum.at(bits, bit_position) == bit_value end)
    |> filter_bit_rows(bit_position + 1, common_fun)
  end
end

Day3Part2.solve()
