defmodule NotacpuTest do
  use ExUnit.Case
  doctest Notacpu

  test "greets the world" do
    assert Notacpu.hello() == :world
  end
end
