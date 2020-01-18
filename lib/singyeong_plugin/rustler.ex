defmodule Singyeong.Plugin.Rustler do
  @moduledoc """
  A helper module to make Rustler-based natives load properly.

  ```Elixir
  defmodule MyNatives do
    use Singyeong.Plugin.Rustler, crate: "mynatives_native"
    # or:
    # use Singyeong.Plugin.Rustler, crate: "", load_data: 0
    #
    # load_data is passed to :erlang.load_nif/2
  end
  ```
  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @on_load :__init__

      @opts opts

      def __init__ do
        :code.purge __MODULE__
        tmp = System.tmp_dir!()
        crate = @opts[:crate]
        crate = if String.starts_with?(crate, "lib"), do: crate, else: "lib#{crate}"
        so_path = "#{tmp}/natives/#{crate}"
        load_data = @opts[:load_data] || 0
        :erlang.load_nif so_path, load_data
      end
    end
  end
end
