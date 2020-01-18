defmodule Singyeong.Plugin.Constants do
  @spec gateway_opcodes() :: %{integer() => atom()}
  defdelegate gateway_opcodes, to: Singyeong.Gateway, as: :opcodes_id
  @spec gateway_opcodes_by_name() :: %{atom() => integer()}
  defdelegate gateway_opcodes_by_name, to: Singyeong.Gateway, as: :opcodes_name

  defp gateway_module, do: Application.get_env :singyeong_plugin, :gateway_module
end
