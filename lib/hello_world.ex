defmodule HelloWorld do
  def main(args) do
    IO.puts "#{length args} argument(s)"
    {max, _} = Integer.parse(hd args)

    caller = self()
    agent = spawn fn -> fizzbuzz_agent(caller) end

    print agent, 0, max
  end

  defp print(agent, from, to) do
    send agent, {:fizzbuzz, from}
    receive do {:fizzbuzz_reply, reply} -> IO.puts reply end

    if from < to do
      print agent, (from + 1), to
    end
  end

  defp fizzbuzz_agent(caller) do
    receive do
      {:fizzbuzz, number} ->
        reply = case number do
          n when rem(n,5) == 0 and rem(n,3) == 0 -> "fizzbuzz"
          n when rem(n,5) == 0                   -> "buzz"
          n when rem(n,3) == 0                   -> "fizz"
          _                                      -> number
        end
        send caller, {:fizzbuzz_reply, reply}
        fizzbuzz_agent(caller)
    end
  end

end
