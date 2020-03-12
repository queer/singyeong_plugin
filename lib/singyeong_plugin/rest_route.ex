defmodule Singyeong.Plugin.RestRoute do
  use TypedStruct

  typedstruct do
    field :method, atom(), enforce: true
    field :route, String.t(), enforce: true
    field :module, atom(), enforce: true
    field :function, atom(), enforce: true
  end
end
