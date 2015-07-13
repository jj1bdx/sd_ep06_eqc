-module(sd_eqc_app).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    sd_eqc_sup:start_link().

stop(_State) ->
    ok.

%% test code

-ifdef(TEST).

simple_test() ->
    ok = application:start(sd_eqc),
    ?assertNot(undefined == whereis(sd_eqc_sup)).

-endif.
