defmodule Ripley.Language do
  @moduledoc """
  The language struct
  """

  @derive [Poison.Encoder]
  defstruct index: 0,
            name: "-",
            url: "",
            subscribers: 0,
            subsstring: "",
            percentage: 0
end
