defmodule FcmMockWeb.FcmController do
  use FcmMockWeb, :controller

  @key_auth_id "authorization"

  alias FcmMock.Fcm
  def send(conn, params) do
    key_auth = conn |> get_req_header(@key_auth_id)
    IO.inspect(["KEY AUTH", key_auth])
    IO.inspect(conn)
    case key_auth do
      [] ->
        conn
        |> put_status(401) # 401 = UNAUTHORIZED
        |> send_resp()
      _ ->
        json_payload =
          params
          |> Map.get("_json")
        headers =
          conn
          |>
        Fcm.send(conn, json_payload)
        conn
        |> send_resp(200, "Sent\n")
    end
  end
end
