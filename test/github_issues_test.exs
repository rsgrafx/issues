defmodule GithubIssuesTest do
  
  use ExUnit.Case
 
  import Issues.CLI, only: :functions

  test "sort ascending orders" do 
    result = sort_by_create_date( list_factory( ["z", "a", "d", "h"] ) )
    issues = for issue <- result, do: issue["created_at"]
    assert issues == ~w{ a d h z }
  end

  defp list_factory(values) do
    data = for value <- values,
          do: [{"created_at", value}, {"other_data", "---"}]
    convert_to_hashdicts(data)
  end

end
