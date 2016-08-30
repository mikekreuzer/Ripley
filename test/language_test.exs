defmodule LanguageTest do
  use ExUnit.Case, async: false
  alias Ripley.Language

  describe "Ripley.Language struct" do
    test "defaults" do
      assert %Language{} == %Language{count: 0, countStr: "", name: "-", url: ""}

    end

    test "Poison.Encoder" do
      data = %Language{count: 1, countStr: "1", name: "name", url: "url"}
      encoded = Poison.encode!(data)
      assert encoded == "{\"url\":\"url\",\"name\":\"name\",\"countStr\":\"1\",\"count\":1}"
    end
  end
end
