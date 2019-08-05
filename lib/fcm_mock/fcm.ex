defmodule FcmMock.Fcm do
  @moduledoc """
  Fcm context. Responsible for implementing FcmController's calls
  """

  alias FcmMock.Mock.State
  alias FcmMock.Fcm.Activity

  @doc """
  Mocks Fcm v1 server response and stores activity
  """
  def send(conn, json) do
    message = Map.fetch!(json, :message)
    topic = Map.get(message, :topic)
    token = Map.get(message, :token)
    condition = Map.get(message, :condition)
    target = topic || token || condition

    error =
      State.get_error_tokens()
      |> Map.get(target)
    result =
      case error do
        nil ->
          {:message_id, "23hrjniofwc0923hno"}
        _ ->
          {:error, error}
    end

    activity = %{
      :device_token => target,
      :request_headers =>
    }




      'device_token',
      'request_headers',
      'request_data',
      'response_status',
      'response_data'
  end
end
