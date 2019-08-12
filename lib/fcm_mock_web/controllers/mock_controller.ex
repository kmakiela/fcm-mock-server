defmodule FcmMockWeb.MockController do
  use FcmMockWeb, :controller

  alias FcmMock.Mock
  alias FcmMock.Fcm

  def get_tokens(conn, _params) do
    errors = Mock.get_error_tokens()
    |> convert_to_json
    conn
    |> send_resp(200, errors)
  end

  def set_tokens(conn, params) do
    json_payload =
      params
      |> Map.get("_json")

    Mock.set_error_tokens(json_payload)

    errors =
      Mock.get_error_tokens()
      |> convert_to_json()

    conn
    |> send_resp(200, errors)
  end

  def reset(conn, _params) do
    Mock.reset()
    Fcm.reset()

    conn
    |> send_resp(200, "OK")
  end

  def activity(conn, _params) do
    activity =
      Fcm.get_activity()
      |> convert_to_json()

    conn |>
    send_resp(200, activity)
  end

  defp convert_to_json(object) do
    object
    |> Jason.encode!()
  end
end
