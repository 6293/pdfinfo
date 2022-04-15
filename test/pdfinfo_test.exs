defmodule PdfinfoTest do
  use ExUnit.Case

  defmacro run(str) do
    quote do
      [cmd | args] = String.split(unquote(str))
      {output, 0} = System.cmd(cmd, args)
      output
    end
  end

  test "letter" do
    path = "/tmp/letter.pdf"
    run("convert xc:none -page Letter #{path}")
    {:ok, res} = Pdfinfo.inspect(path)
    assert %{
      npage: "1",
      optimized: false,
      pages: [%{height: 792.0, paper: {:letter, :portrait}, rotation: 0, width: 612.0}],
      producer: "https://imagemagick.org"
    } = res
  end

  test "a4" do
    path = "/tmp/a4.pdf"
    run("convert xc:none -page A4 #{path}")
    {:ok, res} = Pdfinfo.inspect(path)
    assert %{
      npage: "1",
      optimized: false,
      pages: [%{height: 842.0, paper: {:a4, :portrait}, rotation: 0, width: 595.0}],
      producer: "https://imagemagick.org"
    } = res
  end

  test "b4" do
    path = "/tmp/b4.pdf"
    run("convert xc:none -page B4 #{path}")
    {:ok, res} = Pdfinfo.inspect(path)
    assert %{
             npage: "1",
             optimized: false,
             pages: [%{height: 1032.0, paper: {:b4, :portrait}, rotation: 0, width: 729.0}],
             producer: "https://imagemagick.org"
           } = res
  end

  test "likely b4" do
    path = "/tmp/likely_b4.pdf"
    run("convert -size 1033x726 xc:none #{path}")
    {:ok, res} = Pdfinfo.inspect(path)
    assert %{
             npage: "1",
             optimized: false,
             pages: [%{height: 726.0, paper: {:b4, :landscape}, rotation: 0, width: 1033.0}],
             producer: "https://imagemagick.org"
           } = res
  end

  test "unnamed square" do
    path = "/tmp/unnamed_square.pdf"
    run("convert -size 300x300 xc:none #{path}")
    {:ok, res} = Pdfinfo.inspect(path)
    assert %{
             npage: "1",
             optimized: false,
             pages: [%{height: 300.0, paper: {:other, :square}, rotation: 0, width: 300.0}],
             producer: "https://imagemagick.org"
           } = res
  end

  test "unnamed portrait" do
    path = "/tmp/unnamed_square.pdf"
    run("convert -size 300x400 xc:none #{path}")
    {:ok, res} = Pdfinfo.inspect(path)
    assert %{
             npage: "1",
             optimized: false,
             pages: [%{height: 400.0, paper: {:other, :portrait}, rotation: 0, width: 300.0}],
             producer: "https://imagemagick.org"
           } = res
  end

  test "unnamed landscape" do
    path = "/tmp/unnamed_square.pdf"
    run("convert -size 400x300 xc:none #{path}")
    {:ok, res} = Pdfinfo.inspect(path)
    assert %{
             npage: "1",
             optimized: false,
             pages: [%{height: 300.0, paper: {:other, :landscape}, rotation: 0, width: 400.0}],
             producer: "https://imagemagick.org"
           } = res
  end

  test "2 pages" do
    run("convert xc:none -page Letter /tmp/page1.pdf")
    run("convert xc:none -page A3 /tmp/page2.pdf")
    run("convert /tmp/page1.pdf /tmp/page2.pdf /tmp/merged.pdf")
    {:ok, res} = Pdfinfo.inspect("/tmp/merged.pdf")
    assert %{
             npage: "2",
             optimized: false,
             pages: [
               %{
                 height: 792.0,
                 paper: {:letter, :portrait},
                 rotation: 0,
                 width: 612.0
               },
               %{height: 1191.0,
                 paper: {:a3, :portrait},
                 rotation: 0,
                 width: 842.0}
             ],
             producer: "https://imagemagick.org"} = res
  end
end
