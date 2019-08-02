defmodule FcmMockWeb.Router do
  use FcmMockWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FcmMockWeb do
    pipe_through :api
  end
end
