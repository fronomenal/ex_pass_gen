defmodule PassgenTest do
  use ExUnit.Case

  setup do
    options = %{"len" => "8", "nums" => "false", "caps" => "false", "syms" => "false"}

    expected = %{
      lows: Enum.map(?a..?z, &<<&1>>),
      nums: Enum.map(0..9, &Integer.to_string(&1)),
      upps: Enum.map(?A..?Z, &<<&1>>),
      syms: String.split("!#$%&()%+,-./:;<=>?@[]^_{|}~", "", trim: true)
    }

    {:ok, res} = PassGen.gen(options)

    %{expected: expected, res: res}

  end

  test "returns a string", %{res: res} do
    assert is_bitstring(res)
  end
  test "returns an error when no length is given" do
    options = %{"invalid" => "true"}

    assert {:err, _} = PassGen.gen(options)
  end
  test "returns an error when length is not an integer" do
    options = %{"len" => "*"}

    assert {:err, _} = PassGen.gen(options)
  end
  test "length of returned string is the provided option" do
    options = %{"len" => "6"}

    {:ok, res} = PassGen.gen(options)

    assert String.to_integer(options["len"]) == String.length(res)
  end
  test "returns only lowercase string as default", %{expected: wants} do
    options = %{"len" => "6"}

    {:ok, res} = PassGen.gen(options)

    assert !String.contains?(res, wants.upps)
    refute String.contains?(res, wants.nums)
    refute String.contains?(res, wants.syms)
  end
  test "Returns error when all options except len are not bools" do
    options = %{"len" => "6", "syms" => "invalid"}

    assert {:err, _} = PassGen.gen(options)
  end
  test "Returns error for invalid options" do
    options = %{"len" => "6", "invalid" => "true"}

    assert {:err, _} = PassGen.gen(options)
  end
  test "Returns uppercase characters when caps flag is set", %{expected: wants} do
    options = %{"len" => "6", "caps" => "true"}

    assert {:ok, res} = PassGen.gen(options)

    assert String.contains?(res, wants.upps)
    refute String.contains?(res, wants.nums)
    refute String.contains?(res, wants.syms)
  end
  test "Returns numbers when nums flag is set", %{expected: wants} do
    options = %{"len" => "6", "nums" => "true"}

    assert {:ok, res} = PassGen.gen(options)

    assert String.contains?(res, wants.nums)
    refute String.contains?(res, wants.upps)
    refute String.contains?(res, wants.syms)
  end
  test "Returns numbers and uppercase letters when nums and caps flags are set", %{expected: wants} do
    options = %{"len" => "6", "nums" => "true", "caps" => "true"}

    assert {:ok, res} = PassGen.gen(options)

    assert String.contains?(res, wants.nums)
    assert String.contains?(res, wants.upps)
    refute String.contains?(res, wants.syms)
  end
  test "Returns symbols when symb flag is set", %{expected: wants} do
    options = %{"len" => "6", "syms" => "true"}

    assert {:ok, res} = PassGen.gen(options)

    refute String.contains?(res, wants.nums)
    refute String.contains?(res, wants.upps)
    assert String.contains?(res, wants.syms)
  end
  test "Returns symbols and numbers letters when syms and nums flags are set", %{expected: wants} do
    options = %{"len" => "6", "syms" => "true", "nums" => "true"}

    assert {:ok, res} = PassGen.gen(options)

    assert String.contains?(res, wants.nums)
    assert String.contains?(res, wants.syms)
    refute String.contains?(res, wants.upps)
  end
  test "Returns symbols, numbers and uppercase letters when syms, nums and caps flags are set", %{expected: wants} do
    options = %{"len" => "6", "syms" => "true", "nums" => "true", "caps" => "true"}

    assert {:ok, res} = PassGen.gen(options)

    assert String.contains?(res, wants.nums)
    assert String.contains?(res, wants.upps)
    assert String.contains?(res, wants.syms)
  end

end
