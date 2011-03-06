-module(pingpong).
-export([start/1, ping/1, loop/1]).

% The public API.

start(Name) ->
  spawn_link(?MODULE, loop, [{pingpong, Name}]).

ping(Pid) ->
  Pid ! {ping, self()},
  receive
    {pong, Pid, Result} -> {ok, Result}
    after 10 -> {error, timeout} end.

% The server.

loop({pingpong, Name} = State) ->
  receive
    {ping, Sender} ->
      Sender ! {pong, self(), {Name}},
      loop(State);

    Unknown ->
      error_logger:warning_msg("~p: Unhandled message: ~p",
                               [State, Unknown]),
      loop(State) end.
