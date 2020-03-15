defmodule Singyeong.Plugin.Payload do
  # Yeah, this module uses some APIs that EXIST, but that I don't want to pull
  # in to here because it doesn't really make a lot of sense. It's a bit silly,
  # I guess, but it works, and the only thing we lose is a little type-safety
  # in this API package.
  alias Singyeong.Plugin.Constants

  @spec create_payload(binary(), any()) :: {:text, map()}
  def create_payload(type, data) when is_binary(type) do
    dispatch = Constants.gateway_opcodes_by_name()[:dispatch]
    apply payload_module(), :create_payload, [dispatch, type, data]
  end

  def create_payload(nil, _) do
    raise ArgumentError, "`type` is required when creating plugin payloads!"
  end

  defp payload_module, do: Application.get_env :singyeong_plugin, :payload_module
end
