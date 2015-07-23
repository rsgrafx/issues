defmodule GithubIssues do

  import Issues.CLI, only: :functions
  # @user_agent ["User-Agent", "Elixir orion.engleton@gmail.com"]
  @github_url Application.get_env(:issues, :github_url)

  def fetch( user, project) do 
    issues_url( user, project)
    |> HTTPoison.get
    |> handle_response
  end

  def issues_url(user, project) do 
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, :jsx.decode(body)}
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: __ , body: body}}) do
   {:error, :jsx.decode(body) }
  end

end
