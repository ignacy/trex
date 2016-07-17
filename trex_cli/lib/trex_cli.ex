defmodule TrexCLI do
  def main(args) do
    {options, _, _} = OptionParser.parse(args,
    switches: [host: :string, port: :integer],
    aliases: [h: :host, p: :port])

    host = Keyword.get(options, :host, '127.0.0.1')
    port = Keyword.get(options, :port, 4040)

    TrexCLI.Supervisor.start_link(host, port)

    loop(host, port)
  end

  def loop(host, port) do
    command = IO.gets("#{host}:#{port}> ")

    reply = command
    |> String.trim_trailing
    |> String.replace(" ", "\t")
    |> TrexCLI.Client.command

    IO.puts reply

    loop(host, port)
  end
end
