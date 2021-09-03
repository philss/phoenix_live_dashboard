defmodule PLDS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    ensure_distribution!()
    set_cookie()

    children = [
      # Start the Telemetry supervisor
      PLDSWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PLDS.PubSub},
      # Start the Endpoint (http/https)
      PLDSWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PLDS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp ensure_distribution!() do
    unless Node.alive?() do
      case System.cmd("epmd", ["-daemon"]) do
        {_, 0} ->
          :ok

        _ ->
          PLDS.Utils.abort!("""
          could not start epmd (Erlang Port Mapper Driver). PLDS uses epmd to \
          talk to different runtimes. You may have to start epmd explicitly by calling:

              epmd -daemon

          Or by calling:

              elixir --sname test -e "IO.puts node()"

          Then you can try booting PLDS again
          """)
      end

      {type, name} = get_node_type_and_name()

      case Node.start(name, type) do
        {:ok, _} ->
          :ok

        {:error, reason} ->
          PLDS.Utils.abort!("could not start distributed node: #{inspect(reason)}")
      end
    end
  end

  defp set_cookie() do
    cookie = Application.fetch_env!(:plds, :cookie)
    Node.set_cookie(cookie)
  end

  defp get_node_type_and_name() do
    Application.get_env(:plds, :node) || {:shortnames, random_short_name()}
  end

  defp random_short_name() do
    :"plds_#{PLDS.Utils.random_short_id()}"
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PLDSWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
