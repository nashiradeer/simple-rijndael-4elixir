defmodule SimpleRijndaelTest do
  use ExUnit.Case
  doctest SimpleRijndael

  test "greets the world" do
    assert SimpleRijndael.hello() == :world
  end
end
