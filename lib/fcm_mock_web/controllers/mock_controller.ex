defmodule FcmMockWeb.MockController do
  use FcmMockWeb, :controller

  alias FcmMock.Mock.ErrorConfig
  alias FcmMock.Mock.Activity

  @key_device_token "device_token"
  @key_status "status"
  @key_reason "reason"
  @key_timestamp "timestamp"

  def get_tokens(conn, _params) do
    json(conn, ErrorConfig.get_error_tokens())
  end

  def set_tokens(conn, params) do
    json_payload =
      params
      |> Map.get("_json")

    case Enum.all?(json_payload, fn map ->
      Enum.all?([@key_device_token, @key_status, @key_reason], fn key ->
        Map.has_key?(map, key)
       end)
    end) do
      false ->
        conn |> send_resp(400, "Bad error configuration")
      true ->
        token_errors = List.foldl(json_payload, %{}, fn error_map, acc -> Map.merge(acc, convert_error(error_map))end)
        ErrorConfig.set_error_tokens(token_errors)
        json(conn, ErrorConfig.get_error_tokens())
    end
  end

  def reset(conn, _params) do
    ErrorConfig.reset()
    Activity.reset()

    conn
    |> send_resp(200, "OK")
  end

  def activity(conn, _params) do
    json(conn, Activity.get_activity())
  end

  defp convert_error(error_map) do
    token = Map.fetch!(error_map, @key_device_token)
    reason = Map.fetch!(error_map, @key_reason)
    status = Map.fetch!(error_map, @key_status)
    timestamp = Map.get(error_map, @key_timestamp)

    token_map =
      %{
        :reason => reason,
        :status => status
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
        Map.merge(map, %{:timestamp => timestamp})
    end
  end
end
