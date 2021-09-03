defmodule PLDS.Utils do
  @doc """
  Parses and validates the ip from env.
  """
  def ip!(env) do
    if ip = System.get_env(env) do
      ip!(env, ip)
    end
  end

  @doc """
  Parses and validates the ip within context.
  """
  def ip!(context, ip) do
    case ip |> String.to_charlist() |> :inet.parse_address() do
      {:ok, ip} ->
        ip

      {:error, :einval} ->
        abort!("expected #{context} to be a valid ipv4 or ipv6 address, got: #{ip}")
    end
  end

  @doc """
  Aborts booting due to a configuration error.
  """
  @spec abort!(String.t()) :: no_return()
  def abort!(message) do
    IO.puts("\nERROR!!! [Livebook] " <> message)
    System.halt(1)
  end

  @doc """
  Generates a random short binary id.
  """
  @spec random_short_id() :: binary()
  def random_short_id() do
    :crypto.strong_rand_bytes(5) |> Base.encode32(case: :lower)
  end
end
