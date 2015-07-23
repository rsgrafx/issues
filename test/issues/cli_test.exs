defmodule Issues.CLITest do
  use ExUnit.Case

  import Issues.CLI, only: [ parse_args: 1 ]

  test ":help returned by parsing  -h and" do 
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test " three values returned if three given" do 
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two values given" do 
    assert parse_args(["user", "project"]) == {"user", "project", 5}
  end

end
