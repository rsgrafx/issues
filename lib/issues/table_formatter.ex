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

  def format_for( list_of_widths ) do
    map_join( list_of_widths, " | ", fn width -> "~-#{width}s" end ) <> "~n"
  end

  def widths_of( columns ) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end

  def printable_table_for_columns( rows, headers) do
    dclmns    = split_into_columns(rows, headers)
    c_widths  = widths_of( dclmns )
    format    = format_for( c_widths )

    puts_one_line_in_columns headers, format
    IO.puts separator(c_widths)
    puts_in_columns dclmns, format
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_one_line_in_columns(fields, format) do 
    :io.format(format, fields)
  end

  def puts_in_columns( data, format) do
    data |> List.zip |> map( &Tuple.to_list/1 ) |> each(&puts_one_line_in_columns(&1, format))
  end

end