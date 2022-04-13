# Pdfinfo

```elixir
iex(1)> Pdfinfo.inspect("/home/kiyofuji/Downloads/03_b_23syakai_tyu-combined.pdf")
{:ok,
  %{
    creator: "Chromium",
    npage: "5",
    optimized: true,
    pages: [
      %{height: 841.89, paper: {:a4, :portrait}, rotation: "0", width: 595.276},
      %{height: 841.89, paper: {:a4, :portrait}, rotation: "0", width: 595.276},
      %{height: 841.89, paper: {:a4, :portrait}, rotation: "0", width: 595.276},
      %{height: 841.89, paper: {:a4, :portrait}, rotation: "0", width: 595.276},
      %{height: 841.92, paper: {:a4, :portrait}, rotation: "0", width: 594.96}
    ],
    producer: "Skia/PDF m93"
  }}
```
