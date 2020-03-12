defmodule Singyeong.Plugin do
  @moduledoc """
  The base plugin behaviour. Your plugin should only have one module
  implementing this behaviour.

  Note that this behaviour is explicitly, **intentionally** NOT implemented as
  a GenServer or similar! You are, of course, free to implement all the
  callbacks in this module as just `GenServer.call(me, :whatever)`, but this is
  not going to be explicitly supported by this behaviour. The reasoning for
  this is that it's significantly easier for runtime checks as to whether a
  callback is implemented or not if the behaviour isn't implemented as a
  GenServer-like module. Of course, plugin capabilities exist to help deal with
  this concern, but I find that it's easier to simply not take that risk and
  enforce a certain implementation style rather than risking potential runtime
  crashes due to capabilities being claimed without implementation.
  """

  @type event() :: any()
  @type undo_state() :: any()
  @type frame() :: {:text, map()}
  @type auth_string() :: binary()
  @type ip() :: binary()
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

  Requires the `:custom_events` capability.

  Plugin event handling behaves in a middleware-type fashion. A plugin can
  choose to pass execution to the next plugin in the chain via `:next`, halt
  execution with `:halt`, or return an error. Returning an error immediately
  halts execution and unwinds as much as possible. Halting will immediately
  stop processing of the event, and will not return anything to the client, as
  it is assumed that the halted execution was not meant to return any
  side-effects to the client.

  On success, this function returns a tuple starting with either `:next` or
  `:halt`

  In non-halt cases, the third return element is the undo state. This is some
  state that the plugin uses to undo any stateful changes it may have made
  during the processing of this event, such that any error can result in a
  rollback of stateful changes. Pure functions may simply return `nil` for the
  undo state, or just not include it as an element of the tuple. **Note that a
  `nil` undo state is assumed to mean that this function has *nothing* to undo,
  and as such the undo function for this module will *never* be called if the
  event handled by this function requires undo!** That is, **returning an undo
  state of `nil` means that your undo function will never be called**. The
  reason for this is simply that **the order in which `handle_event` vs `undo`
  is called cannot be guaranteed**, and so you cannot rely on strict ordering
  of these function calls for reliable undo behaviour.

  # TODO: Provide a real interface for listening on all events.
  """
  @callback handle_event(binary(), any()) ::
              {:next, [frame()], undo_state()}
              | {:next, frame(), undo_state()}
              | {:next, [frame()]}
              | {:next, frame()}
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

  @doc """
  Called when a client identifies with the server. The auth string the client
  sends, as well as the client's IP address, are passed to this function. Note
  that **there is no guarantee of IPv4 vs IPv6 address**, and your code should
  be able to handle both cases.

  Requires the `:auth` capability.
  """
  @callback auth(auth_string(), ip()) :: :ok | :restricted | {:error, binary()}
end
