defmodule PLDSCli.Server do
  @moduledoc false

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

  @impl true
  def call(args) do
    opts = args_to_options(args)
    config_entries = opts_to_config(opts, [])
    put_config_entries(config_entries)

    port = Application.get_env(:plds, PLDSWeb.Endpoint)[:http][:port]
    base_url = "http://localhost:#{port}"

    case check_endpoint_availability(base_url) do
      :livebook_running ->
        IO.puts("PLDS already running on #{base_url}")
        open_from_options(base_url, opts)

      :taken ->
        print_error(
          "Another application is already running on port #{port}." <>
            " Either ensure this port is free or specify a different port using the --port option"
        )

      :available ->
        case start_server() do
          :ok ->
            open_from_options(PLDSWeb.Endpoint.url(), opts)
            Process.sleep(:infinity)

          :error ->
            print_error("PLDS failed to start")
        end
    end
  end

  # Takes a list of {app, key, value} config entries
  # and overrides the current applications' configuration accordingly.
  # Multiple values for the same key are deeply merged (provided they are keyword lists).
  defp put_config_entries(config_entries) do
    config_entries
    |> Enum.reduce([], fn {app, key, value}, acc ->
      acc = Keyword.put_new_lazy(acc, app, fn -> Application.get_all_env(app) end)
      Config.Reader.merge(acc, [{app, [{key, value}]}])
    end)
    |> Application.put_all_env(persistent: true)
  end

  defp check_endpoint_availability(_base_url), do: :available
  # defp check_endpoint_availability(base_url) do
  #   Application.ensure_all_started(:inets)

  #   health_url = append_path(base_url, "health")

  #   case Livebook.Utils.HTTP.request(:get, health_url) do
  #     {:ok, status, _headers, body} ->
  #       with 200 <- status,
  #            {:ok, body} <- Jason.decode(body),
  #            %{"application" => "plds"} <- body do
  #         :livebook_running
  #       else
  #         _ -> :taken
  #       end

  #     {:error, _error} ->
  #       :available
  #   end
  # end

  defp start_server() do
    # We configure the endpoint in prod with `server: true`,
    # so it's gonna start listening
    case Application.ensure_all_started(:plds) do
      {:ok, _} -> :ok
      {:error, _} -> :error
    end
  end

  defp open_from_options(base_url, opts) do
    if opts[:open] do
      browser_open(base_url)
    end
  end

  @switches [
    cookie: :string,
    ip: :string,
    name: :string,
    open: :boolean,
    port: :integer,
    sname: :string
  ]

  @aliases [
    p: :port
  ]

  defp args_to_options(args) do
    {opts, _} = OptionParser.parse!(args, strict: @switches, aliases: @aliases)
    validate_options!(opts)
    opts
  end

  defp validate_options!(opts) do
    if Keyword.has_key?(opts, :name) and Keyword.has_key?(opts, :sname) do
      raise "the provided --sname and --name options are mutually exclusive, please specify only one of them"
    end
  end

  defp opts_to_config([], config), do: config

  defp opts_to_config([{:port, port} | opts], config) do
    opts_to_config(opts, [{:plds, PLDSWeb.Endpoint, http: [port: port]} | config])
  end

  defp opts_to_config([{:ip, ip} | opts], config) do
    ip = PLDS.Utils.ip!("--ip", ip)
    opts_to_config(opts, [{:plds, PLDSWeb.Endpoint, http: [ip: ip]} | config])
  end

  defp opts_to_config([{:sname, sname} | opts], config) do
    sname = String.to_atom(sname)
    opts_to_config(opts, [{:plds, :node, {:shortnames, sname}} | config])
  end

  defp opts_to_config([{:name, name} | opts], config) do
    name = String.to_atom(name)
    opts_to_config(opts, [{:plds, :node, {:longnames, name}} | config])
  end

  defp opts_to_config([{:cookie, cookie} | opts], config) do
    cookie = String.to_atom(cookie)
    opts_to_config(opts, [{:plds, :cookie, cookie} | config])
  end

  defp opts_to_config([_opt | opts], config), do: opts_to_config(opts, config)

  defp browser_open(url) do
    {cmd, args} =
      case :os.type() do
        {:win32, _} -> {"cmd", ["/c", "start", url]}
        {:unix, :darwin} -> {"open", [url]}
        {:unix, _} -> {"xdg-open", [url]}
      end

    System.cmd(cmd, args)
  end

  # defp append_path(url, path) do
  #   url
  #   |> URI.parse()
  #   |> Map.update!(:path, &((&1 || "/") <> path))
  #   |> URI.to_string()
  # end

  defp print_error(message) do
    IO.ANSI.format([:red, message]) |> IO.puts()
  end
end
