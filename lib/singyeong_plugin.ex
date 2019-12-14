defmodule Singyeong.Plugin do
  @moduledoc """
  The base plugin behaviour. Your plugin should only have one module
  implementing this behaviour.
  """

  @type event() :: any()
  @type undo_state() :: any()
  # TODO: This type is currently not a part of the API -- we should change this
  @type frame() :: {:text, Singyeong.Gateway.Payload.t()}
  @optional_callbacks handle_event: 2, undo: 2

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
  choose to pass execution to the next plugin in the chain via `:next`, halt
  execution with `:halt`, or return an error. Returning an error immediately
  halts execution and unwinds as much as possible. Halting will immediately
  stop processing of the event, and will not return anything to the client, as
  it is assumed that the halted execution was not meant to return any
  side-effects to the client.

  On success, this function returns a tuple starting with either `:next` or
  `:halt`

  In all cases, the third return element is the undo state. This is some state
  that the plugin uses to undo any stateful changes it may have made during the
  processing of this event, such that any error can result in a rollback of
  stateful changes. Pure functions may simply return `nil` for the undo state,
  or just not include it as an element of the tuple. **Note that a `nil` undo
  state is assumed to mean that this function has *nothing* to undo, and as
  such the undo function for this module will *never* be called if the event
  handled by this function requires undo!** That is, **returning an undo state of
  `nil` means that your undo function will never be called**. The reason for
  this is simply that **the order in which `handle_event` vs `undo` is called
  cannot be guaranteed**, and so you cannot rely on strict ordering of these
  function calls for reliable undo behaviour.

  # TODO: Provide a real interface for listening on all events.
  """
  @callback handle_event(binary(), any()) ::
              {:next, [frame()], undo_state()}
              | {:next, [frame()]}
              | {:halt, undo_state()}
              | :halt
              | {:error, binary(), undo_state()}
              | {:error, binary()}

  @doc """
  Called when this plugin is supposed to undo some stateful changes.
  Implementations of this function are *expected* to be impure, and may do more
  or less whatever they want. The `undo_state` parameter may be **any** value,
  **with the exception that a `nil` undo state will never be passed to this
  function, for any reason**.
  """
  @callback undo(binary(), undo_state()) :: :ok | {:error, binary()}
end
