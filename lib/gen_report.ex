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

  @all_years [
    2016,
    2017,
    2018,
    2019,
    2020
  ]

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  def build(filename) do
    # TO DO
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  defp report_acc do
    all_hours = Enum.into(@all_names, %{}, fn x -> {x, 0} end)
    all_months = Enum.into(@available_months, %{}, fn x -> {x, 0} end)
    all_years = Enum.into(@all_years, %{}, fn x -> {x, 0} end)

    hours_per_month = Enum.map(all_hours, fn {x, _value} -> {x, all_months} end)
    hours_per_year = Enum.map(all_hours, fn {x, _value} -> {x, all_years} end)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => Enum.into(hours_per_month, %{}),
      "hours_per_year" => Enum.into(hours_per_year, %{})
    }
  end

  defp sum_values([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month = sum_per_month(name, hours, month, hours_per_month)
    hours_per_year = sum_per_year(name, hours, year, hours_per_year)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => Enum.into(hours_per_month, %{}),
      "hours_per_year" => Enum.into(hours_per_year, %{})
    }
  end

  defp sum_per_month(name, hours, month, hours_per_month) do
    months = hours_per_month[name]
    months_updated = Map.put(months, month, months[month] + hours)
    Map.put(hours_per_month, name, months_updated)
  end

  defp sum_per_year(name, hours, year, hours_per_year) do
    years = hours_per_year[name]
    years_updated = Map.put(years, year, years[year] + hours)
    Map.put(hours_per_year, name, years_updated)
  end
end
