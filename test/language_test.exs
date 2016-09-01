defmodule LanguageTest do
  use ExUnit.Case, async: false
  alias Ripley.Language

  describe "Ripley.Language struct" do
    test "defaults" do
      assert %Language{} == %Language{index: 0,
                                      name: "-",
                                      url: "",
                                      subscribers: 0,
                                      subsstring: "",
                                      percentage: 0}

    end

    test "Poison.Encoder" do
      data = %Language{index: 1,
                       name: "name",
                       url: "url",
                       subscribers: 2,
                       subsstring: "subsstring",
                       percentage: 3}
      encoded = Poison.encode!(data)
      assert encoded == "{\"url\":\"url\",\"subsstring\":\"subsstring\",\"subscribers\":2,\"percentage\":3,\"name\":\"name\",\"index\":1}"
    end
  end
end
