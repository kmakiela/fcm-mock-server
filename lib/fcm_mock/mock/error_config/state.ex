defmodule FcmMock.Mock.ErrorConfig.State do
  @moduledoc """
  Mock State that stores a set of tokens and their setup using Agent
  """
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_error_tokens do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def add_error_tokens(error_token_map) do
    Agent.update(__MODULE__, fn state ->  Map.merge(state, error_token_map) end)
  end

  def reset do
    Agent.update(__MODULE__, fn _state -> %{} end)
  end
end
