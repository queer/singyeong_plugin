defmodule Singyeong.Plugin do
  @moduledoc """
  The base plugin behaviour. Your plugin should only have one module
  implementing this behaviour.
  """

  @type event() :: any()
  @type undo_state() :: any()
  # TODO: This type is currently not a part of the API -- we should change this
  @type frame() :: {:text, Singyeong.Gateway.Payload.t()}

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

  @doc """
  Called when this plugin is supposed to handle an event. The events passed to
  this function are those specified in `Manifest.events` only. Built-in events
  will never be passed to this function.

  Plugin event handling behaves in a middleware-type fashion. A plugin can
  choose to pass execution to the next plugin in the chain via `:next`. halt
  execution with `:halt`, or return an error. Returning an error immediately
  halts execution and unwinds as much as possible.

  In the non-error cases, the third return element is the undo state. This is
  some state that the plugin uses to undo any stateful changes it may have made
  during the processing of this event, such that any error can result in a
  rollback of stateful changes. Pure functions may simply return `nil`.

  # TODO: Provide a real interface for listening on all events.
  """
  @callback handle_event(binary(), any()) ::
              {:next, list(frame()), undo_state()}
              | {:halt, list(frame()), undo_state()}
              | {:error, binary(), undo_state()}

  # TODO: Provide a real callback to undo with
end
