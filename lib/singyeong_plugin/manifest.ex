defmodule Singyeong.Plugin.Manifest do
  use TypedStruct

  typedstruct do
    field :name, String.t(), enforce: true
    field :description, String.t(), default: "My cool plugin."
    field :website, String.t() | nil, default: nil
    field :events, [String.t()] | [], default: []
    field :capabilities, [atom()] | [], enforce: true
  end
end
