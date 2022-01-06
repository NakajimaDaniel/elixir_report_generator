defmodule GenReport do
  alias GenReport.Parser

  @available_months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  @all_names [
    "daniele",
    "mayk",
    "giuliano",
    "cleiton",
    "jakeliny",
    "joseph",
    "diego",
    "rafael",
    "vinicius",
    "danilo"
  ]

  def build(filename) do
    # TO DO
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  defp report_acc do
    all_hours = Enum.into(@all_names, %{}, fn x -> {x, 0} end)
    all_months = Enum.into(@available_months, %{}, fn x -> {x, 0} end)

    hours_per_month = Enum.map(all_hours, fn {x, _value} -> {x, all_months} end)

    %{"all_hours" => all_hours, "hours_per_month" => Enum.into(hours_per_month, %{})}
  end

  defp sum_values([name, hours, _day, _month, _year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)
    # hours_per_month = Enum.map(hours_per_month, fn x -> Map.put(x, name, x[name] + hours) end)

    %{"all_hours" => all_hours, "hours_per_month" => hours_per_month}
  end
end
