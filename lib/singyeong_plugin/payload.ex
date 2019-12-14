defmodule Singyeong.Plugin.Payload do
  # Yeah, this module uses some APIs that EXIST, but that I don't want to pull
  # in to here because it doesn't really make a lot of sense. It's a bit silly,
  # I guess, but it works, and the only thing we lose is a little type-safety
  # in this API package.
  alias Singyeong.Plugin.Constants

  @spec create_payload(binary(), any()) :: {:text, map()}
  def create_payload(type, data) when is_binary(type) do
    Singyeong.Gateway.Payload.create_payload Constants.gateway_opcodes_by_name()[:dispatch], type, data
  end
  def create_payload(nil, _) do
    raise ArgumentError, "`type` is required when creating plugin payloads!"
  end
end
