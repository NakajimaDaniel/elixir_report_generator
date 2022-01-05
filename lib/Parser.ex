defmodule GenReport.Parser do
  def parse_file(filename) do
    "reports/#{filename}"
    |> File.stream!()
    |> Stream.map(fn line -> line end)
    |> Enum.map(fn x -> parse_line(x) end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(0, fn x -> String.downcase(x) end)
    |> List.update_at(1, fn x -> String.to_integer(x) end)
    |> List.update_at(2, fn x -> String.to_integer(x) end)
    |> List.update_at(3, fn x -> convert_month(x) end)
    |> List.update_at(4, fn x -> String.to_integer(x) end)
  end

  defp convert_month(month) when month == "1", do: "janeiro"
  defp convert_month(month) when month == "2", do: "fevereiro"
  defp convert_month(month) when month == "3", do: "março"
  defp convert_month(month) when month == "4", do: "abril"
  defp convert_month(month) when month == "5", do: "maio"
  defp convert_month(month) when month == "6", do: "junho"
  defp convert_month(month) when month == "7", do: "julho"
  defp convert_month(month) when month == "8", do: "agosto"
  defp convert_month(month) when month == "9", do: "setembro"
  defp convert_month(month) when month == "10", do: "outubro"
  defp convert_month(month) when month == "11", do: "novembro"
  defp convert_month(month) when month == "12", do: "dezembro"
end
