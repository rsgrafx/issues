defmodule Issues.CLI do

  @default_count 5

  @moduledoc """
  Handle the command line parsing and the dispath to the various functions 
  """

  def run(argv) do
    argv 
    |> parse_args
    |> process
  end

  def parse_args( argv ) do
    parse = OptionParser.parse( argv, [ switches: [ help: :boolean], 
                                        aliases: [ h: :help]])
    case parse do 
      {[help: true], _, _ } 
        -> :help
      {_, [user, project, count], _} 
        -> { user, project, String.to_integer(count) }
      {_, [user, project], _}
        -> {user, project, @default_count }
      _ -> :help
    end

  end

  def process(:help) do
    IO.puts "usage: issues <user> <project> [count | #{@default_count}]"
    System.halt(0)
  end

  def process({user, project, count}) do 
    GithubIssues.fetch(user, project)
    |> decode_response
    |> convert_to_hashdicts
    |> sort_by_create_date
    |> Enum.take(count)
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from github #{message}"
    System.halt(2)
  end

  def convert_to_hashdicts( list ) do
    list |> Enum.map( &Enum.into( &1, HashDict.new ))
  end

  def sort_by_create_date( list ) do
    list |> Enum.sort(fn i1, i2 -> i1["created_at"] <= i2["created_at"] end)
  end

end