defmodule FcmMock.Fcm do
  @moduledoc """
  This module implements FCM logic
  """

  @key_message "message"
  @key_topic "topic"
  @key_token "token"
  @key_condition "condition"

  alias FcmMock.Mock.ErrorConfig.State

  @doc """
  Mocks Fcm v1 server response
  """
  def send(path, json) do
    message = Map.fetch!(json, @key_message)
    topic = Map.get(message, @key_topic)
    token = Map.get(message, @key_token)
    condition = Map.get(message, @key_condition)
    target = topic || token || condition

    error =
      State.get_error_tokens()
      |> Map.get(target)

    response_body =
      case error do
        nil ->
          %{
            name: path
          }

        _ ->
          %{
            error: %{
              code: Map.fetch!(error, :status),
              status: Map.fetch!(error, :reason),
              message: ""
            }
          }
    end
    {target, response_body}
  end

  @doc """
  Mocks OAuth server behaviour, more info on: https://developers.google.com/identity/protocols/OAuth2ServiceAccount#authorizingrequests
  """
  def get_access_token do
    %{
      access_token: "fake_token",
      token_type: "Bearer",
      expires_in: 3600
    }
  end
end
