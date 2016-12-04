defmodule Ripley.HTTPMock do
  def get(url, _user_agent, _timeouts) do
    case url do
      "https://www.reddit.com/r/elixir/" ->
        {:ok, %HTTPoison.Response{status_code: 200, body: to_string body_text}}

      "https://www.reddit.com/r/not_there/" ->
        {:ok, %HTTPoison.Response{status_code: 302}}

      "https://www.reddit.com/r/error/" ->
        {:error, %HTTPoison.Error{reason: "Weird error"}}

      _ ->
        {:ok, %HTTPoison.Response{status_code: 200, body: to_string body_text}}
    end
  end

  defp body_text do
    """
    <!DOCTYPE html>
    <head>
    <title>test</title>
    <body>
    <p>other stuff</p>
    <p><span class="subscribers"><span class="number">5,286</span></span></p>
    <p>lots of it</p>
    </body>
    </html>
    """
  end
end
