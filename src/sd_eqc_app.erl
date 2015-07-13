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

counter_test_() ->
    {setup,
     fun counter_start_link/0,
     fun counter_stop/1,
     fun counter_check/1}.

counter_start_link() ->
    {ok, Pid} = msgcounter_gen_server:start_link(),
    Pid.

counter_stop(Pid) ->
    msgcounter_gen_server:stop(Pid).

counter_check(Pid) ->
    [?_assertEqual(0, msgcounter_gen_server:val(Pid)),
    ?_assertEqual(1, msgcounter_gen_server:inc(Pid)),
    ?_assertEqual(2, msgcounter_gen_server:inc(Pid)),
    ?_assertEqual(ok, msgcounter_gen_server:zero(Pid)),
    ?_assertEqual(0, msgcounter_gen_server:val(Pid)),
    ?_assertEqual(1, msgcounter_gen_server:inc(Pid)),
    ?_assertEqual(0, msgcounter_gen_server:dec(Pid)),
    ?_assertEqual(-1, msgcounter_gen_server:dec(Pid)),
    ?_assertEqual(0, msgcounter_gen_server:inc(Pid)),
    ?_assertEqual(0, msgcounter_gen_server:val(Pid))
    ].

-endif.
