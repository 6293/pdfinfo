defmodule Pdfinfo do
  @moduledoc """
  pdfinfo wrapper
  """

  @a0 {2384, 3371, :a0}
  @a1 {1635, 2384, :a1}
  @a2 {1190, 1684, :a2}
  @a3 {842, 1190, :a3}
  @a4 {595, 842, :a4}
  @a5 {420, 595, :a5}
  @b4 {729, 1032, :b4}
  @b5 {516, 729, :b5}
  @letter {612, 792, :letter}
  @papers [@a0, @a1, @a2, @a3, @a4, @a5, @b4, @b5, @letter]

  def inspect(path) do
    with {:ok, output} <- run("pdfinfo #{path}") do
      {:ok, output |> parse |> format |> page_info(path)}
    end
  end

  defp run(cmd) do
    [cmd | args] = String.split(cmd)
    case System.cmd(cmd, args) do
      {output, 0} -> {:ok, output}
      {err, code} -> {:error, {err, code}}
    end
  end

  defp page_info(%{npage: npage} = inspect, path) do
    with {:ok, output} <- run("pdfinfo -f 1 -l #{npage} #{path}"),
         tokens <- parse(output) do
      Map.put(inspect, :pages, do_page_info(tokens, []))
    end
  end

  def do_page_info([], acc) do
    Enum.reverse(acc)
  end

  def do_page_info([{"Page    " <> _, size}, {"Page    " <> _, rot} | columns], acc) do
    [w, _, h | _] = size |> String.split(" ")
    p = paper(w |> Float.parse |> elem(0), h |> Float.parse |> elem(0))
    info = %{width: w |> Float.parse |> elem(0), height: h |> Float.parse |> elem(0), paper: p, rotation: rot}
    do_page_info(columns, [info | acc])
  end

  def do_page_info([_ | columns], acc) do
    do_page_info(columns, acc)
  end

  defp parse(output) do
    tokens = output |> String.split("\n") |> Enum.map(fn x -> x |> String.split(":", parts: 2, trim: true) end)
    tokens |> Enum.filter(&(!Enum.empty?(&1))) |> Enum.map(fn [k, v] -> {k, String.trim(v)} end)
  end

  def format(columns) do
    format(columns, %{})
  end

  defp format([], acc) do
    acc
  end

  defp format([{"Pages", npage} | columns], acc) do
    format(columns, Map.put(acc, :npage, npage))
  end

  defp format([{"Creator", creator} | columns], acc) do
    format(columns, Map.put(acc, :creator, creator))
  end

  defp format([{"Producer", producer} | columns], acc) do
    format(columns, Map.put(acc, :producer, producer))
  end

  defp format([{"Optimized", optimized} | columns], acc) do
    format(columns, Map.put(acc, :optimized, optimized == "yes"))
  end

  defp format([_ | columns], acc) do
    format(columns, acc)
  end

  defp paper(w, h) do
    case Enum.find(@papers, fn target_wh -> page_dimension_equal(target_wh, {w, h}) end) do
      {_, _, target} -> {target, :portrait}
      _ ->
        case Enum.find(@papers, fn target_wh -> page_dimension_equal(target_wh, {h, w}) end) do
          {_, _, target} -> {target, :landscape}
          _ -> :other
        end
    end
  end

  defp page_dimension_equal({w, h, _}, {my_w, my_h}) do
    abs(w - my_w) < 5 and abs(h - my_h) < 5
  end
end
