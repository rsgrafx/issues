defmodule Issues.TableFormatter do
  import Enum, only: [ each: 2, map: 2, map_join: 3, max: 1 ]

  def split_into_columns( rows, headers) do 
    for header <- headers do 
      IO.puts header
      for row <- rows, do: printable(row[header])
    end
  end

  def printable(str) when is_binary(str), do: str

  def printable(str), do: to_string(str)

end