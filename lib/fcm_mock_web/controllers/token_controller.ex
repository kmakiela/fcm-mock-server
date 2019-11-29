defmodule FcmMockWeb.TokenController do
  use FcmMockWeb, :controller

  @token "123"
  @token_type "Bearer"
  @expiration 3600

  def get(conn, _params) do
    token =
      get_token
      |> convert_to_json

    conn
    |> send_resp(200, token)
  end

  defp get_token do
    %{"access_token" => @token, "token_type" => @token_type, "expires_in" => @expiration}
  end

  defp convert_to_json(object) do
    object
    |> Jason.encode!()
  end
end
