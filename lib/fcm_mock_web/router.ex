defmodule FcmMockWeb.Router do
  use FcmMockWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FcmMockWeb do
    pipe_through :api
  end

  scope "/mock", as: :mock do
    pipe_through :api
    get "/error-tokens", FcmMockWeb.MockController, :get_tokens
    post "/error-tokens", FcmMockWeb.MockController, :set_tokens
    put "/error-tokens", FcmMockWeb.MockController, :set_tokens
    post "/reset", FcmMockWeb.MockController, :reset
    put "/reset", FcmMockWeb.MockController, :reset
    get "/activity", FcmMockWeb.MockController, :activity
  end

  post "/v1/:project_id/messages:send", FcmMockWeb.FcmController, :send
  get "/healthcheck", FcmMockWeb.HealthcheckController, :check
end
