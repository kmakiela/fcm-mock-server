defmodule FcmMockWeb.FcmController do
  use FcmMockWeb, :controller

  @key_auth_id "authorization"

  alias FcmMock.Fcm
  def send(conn, params) do
    key_auth = conn |> get_req_header(@key_auth_id)
    case key_auth do
      [] ->
        conn
        |> send_resp(401, "Authorization header is required")

      _ ->
        headers = conn.req_headers
        path = conn.request_path

        response_body = Fcm.send(path, headers, params)
        response =  convert_response_to_json(response_body)

        conn
         |> send_resp(response_body[:error][:code] || 200, response)
    end
  end

  defp convert_response_to_json(response_body) do
    response_body
      |> Jason.encode!()
  end
end
