defmodule Singyeong.Plugin do
  @moduledoc """
  The base plugin behaviour. Your plugin should only have one module
  implementing this behaviour.
  """

  @doc """
  Provides information about the plugin. This is cached when the plugin is
  loaded.
  """
  @callback manifest() :: Singyeong.Plugin.Manifest.t()

  @doc """
  Called when the plugin is first loaded. Returns a list of children to be
  added to the initial supervision tree.
  """
  @callback load() ::
              {:ok,
               [
                 :supervisor.child_spec()
                 | {module(), term()}
                 | module()
                 | Supervisor.child_spec()
               ]}
              | {:ok, []}
              | {:ok, nil}
              | {:error, binary()}
end
