defmodule FcmMockWeb.FcmController do
  use FcmMockWeb, :controller

  @key_auth_id "authorization"

  alias FcmMock.Fcm
  alias FcmMock.Mock.Activity

  def send(conn, params) do
    key_auth = conn |> get_req_header(@key_auth_id)
    case key_auth do
      [] ->
        conn
        |> send_resp(401, "Authorization header is required")

      _ ->
        path = conn.request_path
        {target, response_body} = Fcm.send(path, params)

        headers = conn.req_headers
        response_code = response_body[:error][:code] || 200
        Activity.log_activity(target, headers, params, response_code, response_body)

        response =  convert_response_to_json(response_body)

        conn
         |> send_resp(response_code, response)
    end
  end

  def get_access_token(conn, _params) do
    response =
      Fcm.get_access_token()
      |> convert_response_to_json()

    conn
      |> send_resp(200, response)

  end

  defp convert_response_to_json(response_body) do
    response_body
      |> Jason.encode!()
  end
end
