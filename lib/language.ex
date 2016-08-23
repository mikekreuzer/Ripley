defmodule Ripley.Language do
  @moduledoc """
  The language struct
  """

  @derive [Poison.Encoder]
  defstruct name: "-", url: "", countStr: "", count: 0
end
