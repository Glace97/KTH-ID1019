defmodule MandelTest do
  use ExUnit.Case
  doctest Mandel

  test "greets the world" do
    assert Mandel.hello() == :world
  end
end
