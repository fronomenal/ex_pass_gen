defmodule PassGen.CLI do

  def main(args \\ []) do
    {:ok, options} = Agent.start_link( fn -> %{} end )

    {_, res} = args |> get_args() |> response(options)

    Agent.stop(options)

    IO.puts(res)
  end

  defp get_args(args) do


    {opts,length,_}= args |> OptionParser.parse(strict: [caps: :boolean, nums: :boolean, syms: :boolean], aliases: [c: :caps, n: :nums, s: :syms])

    {opts, List.to_string(length)}
  end

  defp response({opts, len}, options) do
    Agent.update(options, fn state -> Map.put_new(state, "len", len) end)

    Enum.each(opts, fn {key, value} -> Agent.update(options, fn state -> Map.put_new(state, to_string(key), Atom.to_string(value)) end) end)

    PassGen.gen(Agent.get(options, fn state -> state end))
  end
end
