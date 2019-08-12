defmodule FcmMock.Mock do
  @moduledoc """
  Mock context. Responsible for implementing MockController's calls
  """

  alias FcmMock.Mock.State
  alias FcmMock.Fcm

  @key_device_token "device_token"
  @key_status "status"
  @key_reason "reason"
  @key_timestamp "timestamp"

  @doc """
  Returns current token setup
  """
  def get_error_tokens() do
    State.get_error_tokens()
  end

  @doc """
  Updates Mock state with token setups. Params is in a form of %{"_json" => token_setups}
  """
  def set_error_tokens(json) do
    tokens =
      json
      |> List.foldl(%{}, fn error_map, acc -> Map.merge(acc, convert_error(error_map)) end)

    State.add_error_tokens(tokens)
  end

  @doc """
  Resets the test server status
  """
  def reset() do
    Agent.update(State, fn _state -> %{} end)
  end

  @doc """
  Returns activity dump
  """
  def get_activity() do
    Fcm.get_activity()
  end

  defp convert_error(error_map) do
    token = Map.fetch!(error_map, @key_device_token)
    reason = Map.fetch!(error_map, @key_reason)
    status = Map.fetch!(error_map, @key_status)
    timestamp = Map.get(error_map, @key_timestamp)

    token_map =
      %{
        @key_reason => reason,
        @key_status => status
      } |> maybe_add_timestamp(timestamp)

    %{
        token => token_map
    }
  end

  defp maybe_add_timestamp(map, timestamp) do
    case timestamp do
      nil ->
        map
      _ ->
        Map.merge(map, %{@key_timestamp => timestamp})
    end
  end

end
