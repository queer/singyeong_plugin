defmodule Singyeong.Plugin.Constants do
  @spec gateway_opcodes() :: %{integer() => atom()}
  def gateway_opcodes do
    apply gateway_module(), :opcodes_id, []
  end
  @spec gateway_opcodes_by_name() :: %{atom() => integer()}
  def gateway_opcodes_by_name do
    apply gateway_module(), :opcodes_name, []
  end

  defp gateway_module, do: Application.get_env :singyeong_plugin, :gateway_module
end
