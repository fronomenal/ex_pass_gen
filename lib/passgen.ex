defmodule PassGen do
  @moduledoc """
  Generates random passwords depending on parameters, main function is 'gen(options)'.
  The main function takes an options string map:
    options = %{"len" => "6", "nums" => "false", "caps" => "false", "syms" => "false"}
  Len signifies the generated length. nums sets if numbers are generated; caps, syms also do the same but for uppercase letters and symbols
  """

  @valid_options [:len, :nums, :caps, :syms]

  @doc """
  Generates password with options input

  ## Examples

    options = %{"len" => "6", "nums" => "false", "caps" => "false", "syms" => "false"}

    PassGen.gen(options) #abcdefg


    options = %{"len" => "6", "nums" => "true", "caps" => "false", "syms" => "true"}

    PassGen.gen(options) #@b3defg

  """
  @spec gen(options :: map()) :: {:ok, bitstring()} | {:err, bitstring()}
  def gen(options) do
    length = Map.has_key?(options, "len")
    validate_length(length, options)
  end


  defp validate_length(false, _), do: {:err, "Please provide a length"}
  defp validate_length(true, options) do
    length = options["len"] |> String.trim()
    valid = Regex.match?(~r/^\d$/, length)
    validate_length_type(valid, options)
  end

  defp validate_length_type(false, _), do: {:err, "Only integers allowed for length"}
  defp validate_length_type(true, options) do
    length = options["len"] |> String.to_integer()
    option_flags = Map.delete(options, "len")
    valid = option_flags |> Enum.all?(fn {_, fl} -> String.to_atom(fl) |> is_boolean() end)
    validate_options(valid, length, option_flags)
  end

  defp validate_options(false, _, _), do: {:err, "Options values must be booleans"}
  defp validate_options(true, length, flags) do
    options = atomize_options(flags)
    invalid = options |> Enum.any?(&(&1 not in @valid_options))
    validate_allowed_options(invalid, length, options)
  end

  defp atomize_options(options) do
    Enum.filter(options, fn {_, value} -> value |> String.trim() |> String.to_existing_atom() end)
    |> Enum.map(fn {key, _} -> String.to_atom(key) end)
  end

  defp validate_allowed_options(true, _, _), do: {:err, "Invalid option included"}
  defp validate_allowed_options(false, length, options) do
    generate(length, [:lows | options])
  end

  defp generate(length, options) do
    char_list = Enum.map(1..length, fn _ -> Enum.random(options) |> get_char() end)
    get_result(char_list)
  end

  def get_result(chars) do
    password = chars |> Enum.shuffle() |> to_string()
    {:ok, password}
  end

  defp get_char(:lows), do: <<Enum.random(?a..?z)>>
  defp get_char(:caps), do:  <<Enum.random(?A..?Z)>>
  # defp get_char(:nums), do:
  # defp get_char(:syms), do:

end
