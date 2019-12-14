defmodule Singyeong.Plugin.Constants do
  @spec gateway_opcodes() :: %{integer() => atom()}
  def gateway_opcodes, do: Singyeong.Gateway.opcodes_id()
  @spec gateway_opcodes_by_name() :: %{atom() => integer()}
  def gateway_opcodes_by_name, do: Singyeong.Gateway.opcodes_name()
end
