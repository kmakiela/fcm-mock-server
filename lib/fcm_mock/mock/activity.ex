defmodule FcmMock.Mock.Activity do
  @moduledoc """
  Module responsible for handling activity logic
  """
  alias FcmMock.Mock.Activity.State


  @doc """
  Returns Fcm activity dump
  """
  def get_activity do
    State.get_activity()
  end

  @doc """
  Stores FCM Activity
  """
  def log_activity(target, headers, request, response_code, response_body) do
    mapped_headers =
      headers
      |> List.foldl(%{}, fn({key, val}, acc) ->
        Map.put(acc, key, val)
       end)

    activity = %{
      target: target,
      request_headers: mapped_headers,
      request_data: request,
      status: response_code,
      response_data: response_body
    }

    State.add_activity(activity)
  end

  @doc """
  Clears Fcm activity
  """
  def reset do
    State.reset()
  end
end
