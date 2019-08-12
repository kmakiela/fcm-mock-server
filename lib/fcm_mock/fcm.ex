defmodule FcmMock.Fcm do
  @moduledoc """
  Fcm context. Responsible for implementing FcmController's calls
  """
  @key_status "status"
  @key_reason "reason"
  @key_message "message"
  @key_topic "topic"
  @key_token "token"
  @key_condition "condition"

  alias FcmMock.Mock.State
  alias FcmMock.Fcm.Activity


  @doc """
  Mocks Fcm v1 server response and stores activity
  """
  def send(path, headers, json) do
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
            code: Map.fetch!(error, @key_status),
            status: Map.fetch!(error, @key_reason),
            message: ""
          }
    end
    mapped_headers =
      headers
      |> List.foldl(%{}, fn({key, val}, acc) ->
        Map.put(acc, key, val)
       end)

    activity = %{
      target: target,
      request_headers: mapped_headers,
      request_data: json,
      status: 200,
      response_data: response_body
    }
    Activity.add_activity(activity)

    response_body
  end

  @doc """
  Clears Fcm activity
  """
  def reset do
    Agent.update(Activity, fn _activity -> [] end)
  end

  @doc """
  Returns Fcm activity dump
  """
  def get_activity do
    Activity.get_activity()
  end
end



