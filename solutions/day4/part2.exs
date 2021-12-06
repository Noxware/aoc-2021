#! /usr/bin/env elixir

defmodule Slot do
  @enforce_keys [:number]
  defstruct [:number, checked?: false]

  def new(number) do
    %Slot{number: number}
  end

  def check(slot) do
    %{slot | checked?: true}
  end
end

defmodule Board do
  @enforce_keys [:rows]
  defstruct [:rows]

  def parse(string_board) do
    rows =
      string_board
      |> String.splitter("\n")
      |> Stream.map(fn row ->
        row
        |> String.trim()
        |> String.split(~r/ +/)
        |> Stream.map(&String.to_integer/1)
        |> Stream.map(&Slot.new/1)
        |> Enum.to_list()
      end)
      |> Enum.to_list()

    %Board{rows: rows}
  end

  def score(%Board{rows: rows}, last_draw) do
    last_draw *
      Enum.reduce(rows, 0, fn row, acc ->
        acc + (Stream.filter(row, &(!&1.checked?)) |> Stream.map(& &1.number) |> Enum.sum())
      end)
  end

  def check(%Board{rows: rows} = board, number) do
    updated_rows =
      rows
      |> Enum.map(fn row ->
        Enum.map(row, fn
          %Slot{number: ^number} = slot -> Slot.check(slot)
          slot -> slot
        end)
      end)

    %{board | rows: updated_rows}
  end

  defp rotate_with_colums_as_rows(%Board{rows: rows} = board) do
    rotated_rows =
      rows
      |> Stream.zip()
      |> Stream.map(&Tuple.to_list/1)
      |> Enum.to_list()

    %{board | rows: rotated_rows}
  end

  defp won_because_of_rows?(%Board{rows: rows}) do
    rows
    |> Enum.any?(fn row -> Enum.all?(row, & &1.checked?) end)
  end

  def won?(board) do
    won_because_of_rows?(board) or won_because_of_rows?(rotate_with_colums_as_rows(board))
  end
end

defmodule Day4Part2 do
  @this_file_folder Path.dirname(__ENV__.file)

  def solve() do
    [draws | boards] =
      File.read!("#{@this_file_folder}/input.txt")
      |> String.trim()
      |> String.split("\n\n")

    draws =
      draws
      |> String.splitter(",")
      |> Stream.map(&String.to_integer/1)
      |> Enum.to_list()

    playing =
      boards
      |> Stream.map(&Board.parse/1)
      |> Enum.to_list()

    result =
      draws
      |> Enum.reduce(%{playing: playing, winners_with_draw: []}, fn d, acc ->
        played = Enum.map(acc.playing, &Board.check(&1, d))

        # Could be optimized in a single reduce operation

        winners_with_draw =
          Stream.filter(played, &Board.won?/1)
          |> Stream.map(&{&1, d})
          |> Enum.reverse()

        winners_with_draw = winners_with_draw ++ acc.winners_with_draw
        playing = Enum.filter(played, &(!Board.won?(&1)))

        %{playing: playing, winners_with_draw: winners_with_draw}
      end)

    {last_winner, last_draw} = Enum.at(result.winners_with_draw, 0)

    IO.puts(Board.score(last_winner, last_draw))
  end
end

Day4Part2.solve()
