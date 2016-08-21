defmodule Ripley.Language do
  @derive [Poison.Encoder]
  defstruct name: "-", url: "", countStr: "", count: 0
end
