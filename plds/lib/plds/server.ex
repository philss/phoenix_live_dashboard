defmodule PLDS.Server do
  def usage do
    """
    Usage: plds server [options]

    Available options:

      --cookie             Sets a cookie for the app distributed node
      --ip                 The ip address to start the web application on, defaults to 127.0.0.1
                           Must be a valid IPv4 or IPv6 address
      --name               Set a name for the app distributed node
      --open               Open browser window pointing to the application
      -p, --port           The port to start the web application on, defaults to 8080
      --sname              Set a short name for the app distributed node

    The --help option can be given to print this notice.

    """
  end

  def call(_args) do
    case start_server() do
      :ok ->
        IO.ANSI.format([:green, "Starting server"]) |> IO.puts()
        Process.sleep(:infinity)

      :error ->
        IO.ANSI.format([:red, "PLDS failed to start"]) |> IO.puts()
    end
  end

  defp start_server do
    :ok
  end
end
