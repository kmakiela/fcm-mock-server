defmodule FcmMockWeb.SystemController do
  use FcmMockWeb, :controller
  def healthcheck(conn, _params) do
    conn
    |> send_resp(200, "")
  end
end
