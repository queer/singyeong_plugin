defmodule Singyeong.Plugin.Manifest do
  use TypedStruct
  alias Singyeong.Plugin.RestRoute

  typedstruct do
    field :name, String.t(), enforce: true
    field :description, String.t(), default: "My cool plugin."
    field :website, String.t() | nil, default: nil
    field :events, [String.t()] | [], default: []
    field :capabilities, [atom()] | [], enforce: true
    field :native_modules, [atom()] | [], default: []
    field :rest_routes, [RestRoute.t()] | [], default: []
  end
end
