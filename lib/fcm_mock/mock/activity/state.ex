defmodule FcmMock.Mock.Activity.State do
  @moduledoc """
  Module that stores FCM activity using Agent
  """
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def get_activity do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def add_activity(activity) do
    Agent.update(__MODULE__, fn state -> [activity | state] end)
  end

  def reset do
    Agent.update(__MODULE__, fn _activity -> [] end)
  end
end
