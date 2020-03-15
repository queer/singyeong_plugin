defmodule Singyeong.Plugin.Capabilities do
  @capabilities [
    :all_events,
    :custom_events,
    :metadata_access,
    :auth,
    :rest,
  ]

  def capabilities, do: @capabilities

  def is_capability?(atom), do: atom in @capabilities
end
