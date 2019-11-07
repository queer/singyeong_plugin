defmodule SingyeongPluginTest do
  use ExUnit.Case
  doctest SingyeongPlugin

  test "greets the world" do
    assert SingyeongPlugin.hello() == :world
  end
end
