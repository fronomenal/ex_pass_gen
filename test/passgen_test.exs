defmodule PassgenTest do
  use ExUnit.Case

  setup do
    options = %{"len" => "8", "nums" => "false", "caps" => "false", "syms" => "false"}

    opts_type = %{
      lows: Enum.map(?a..?z, &<<&1>>),
      nums: Enum.map(0..9, &Integer.to_string(&1)),
      upps: Enum.map(?A..?Z, &<<&1>>),
      syms: String.split("!#$%&()%+,-./:;<=>?@[]^_{|}~", "", trim: true)
    }

    {:ok, res} = PassGen.gen(options)

    %{opts_type: opts_type, res: res}

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
  test "returns only lowercase string as default", %{opts_type: opts} do
    options = %{"len" => "6"}

    {:ok, res} = PassGen.gen(options)

    assert !String.contains?(res, opts.upps)
    refute String.contains?(res, opts.nums)
    refute String.contains?(res, opts.syms)
  end
  test "Returns error when all options except len are not bools" do
    options = %{"len" => "6", "syms" => "invalid"}

    assert {:err, _} = PassGen.gen(options)
  end
  test "Returns error for invalid options" do
    options = %{"len" => "6", "invalid" => "true"}

    assert {:err, _} = PassGen.gen(options)
  end

end
