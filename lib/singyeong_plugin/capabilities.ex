defmodule Singyeong.Plugin.Capabilities do
  @capabilities [
    :all_events,
    :custom_events,
    :metadata_access,
    :event_creation,
    :auth
  ]

  def capabilities, do: @capabilities

  defp is_capability?(atom), do: atom in @capabilities
end
