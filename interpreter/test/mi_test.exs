defmodule MITest do
  use ExUnit.Case
  doctest MI

  test "greets the world" do
    assert MI.hello() == :world
  end
end
