defmodule GenReport do
  alias GenReport.Parser

  # @available months [
  #   "janeiro",
  #   "fevereiro",
  #   "março",
  #   "abril",
  #   "maio",
  #   "junho",
  #   "julho",
  #   "agosto",
  #   "setembro",
  #   "outubro",
  #   "novembro",
  #   "dezembro"
  # ]

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

    %{"all_hours" => all_hours}
  end

  defp sum_values([name, hours, _day, _month, _year], %{"all_hours" => all_hours}) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    %{"all_hours" => all_hours}
  end
end
