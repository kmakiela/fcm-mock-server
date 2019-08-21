defmodule FcmMockWeb.HealthcheckController do
  use FcmMockWeb, :controller
  def check(conn, _params) do
    conn
    |> send_resp(200, "")
  end
end
