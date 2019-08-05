defmodule FcmMockWeb.MockController do
  use FcmMockWeb, :controller

  alias FcmMock.Mock

  def get_tokens(conn, _params) do
    errors = Mock.get_error_tokens()
    |> convert_state_to_json
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
      |> convert_state_to_json()

    conn
    |> send_resp(200, errors)
  end

  def reset(conn, _params) do
    Mock.reset()

    conn
    |> send_resp(200, "OK")
  end

  def activity(conn, _params) do
    Mock.get_activity(conn)

    conn |>
    send_resp(200, "GET-ACTIVITY")
  end

  defp convert_state_to_json(state) do
    IO.inspect(["STATE: ", state])
    state
    |> Jason.encode!()
  end
end
