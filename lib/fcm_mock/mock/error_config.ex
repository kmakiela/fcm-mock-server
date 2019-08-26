defmodule FcmMock.Mock.ErrorConfig do
  @moduledoc """
  Module responsible for controlling error configuration logic
  """
  alias FcmMock.Mock.ErrorConfig.State

  @doc """
  Returns current token setup
  """
  def get_error_tokens() do
    State.get_error_tokens()
  end

  @doc """
  Updates Mock state with token setups.
  """
  def set_error_tokens(token_errors) do
    State.add_error_tokens(token_errors)
  end

  @doc """
  Resets the test server status
  """
  def reset() do
    State.reset()
  end
end
