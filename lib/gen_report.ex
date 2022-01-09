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

  def build_from_many(filenames) when not is_list(filenames) do
    {:error, "please provide a list of strings"}
  end

  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(fn filename -> build(filename) end)
    |> Enum.reduce(report_acc(), fn {:ok, result}, acc -> sum_reports(acc, result) end)
  end

  defp sum_reports(
         %{
           "all_hours" => all_hours1,
           "hours_per_month" => hours_per_month1,
           "hours_per_year" => hours_per_year1
         },
         %{
           "all_hours" => all_hours2,
           "hours_per_month" => hours_per_month2,
           "hours_per_year" => hours_per_year2
         }
       ) do
    all_hours = merge_maps(all_hours1, all_hours2)
    hours_per_month = merge_nested_map(hours_per_month1, hours_per_month2)
    hours_per_year = merge_nested_map(hours_per_year1, hours_per_year2)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  defp merge_nested_map(map1, map2) do
    map1
    |> Map.merge(map2, fn _k, value1, value2 ->
      value1 |> Map.merge(value2, fn _k, value3, value4 -> value3 + value4 end)
    end)
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

  defp sum_values(
         [name, hours, _day, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         }
       ) do
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
