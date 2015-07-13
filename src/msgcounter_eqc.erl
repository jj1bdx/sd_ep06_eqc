-module(msgcounter_eqc).

-include_lib("eqc/include/eqc.hrl").
-include_lib("eqc/include/eqc_statem.hrl").

-compile(export_all).

-record(state, {count = 0}).

initial_state() ->
     #state{}.

%% zero 

%% {var,pid} stands for the given environment variable "pid" in the tuple
zero_command(_) ->
    {call, msgcounter_gen_server, zero, [{var, pid}]}.

zero_next(S, _, _) ->
    S#state{count = 0}.

zero_post(_, _, Result) ->
    eq(Result, ok).

%% inc

inc_command(_) ->
    {call, msgcounter_gen_server, inc, [{var, pid}]}.

inc_next(S, _, _) ->
    S#state{count = S#state.count + 1}.

inc_post(S, _, Result) ->
    eq(Result, S#state.count + 1).

%% dec

dec_command(_) ->
    {call, msgcounter_gen_server, dec, [{var, pid}]}.

dec_next(S, _, _) ->
    S#state{count = S#state.count - 1}.

dec_post(S, _, Result) ->
    eq(Result, S#state.count - 1).

%% val 

val_command(_) ->
    {call, msgcounter_gen_server, val, [{var, pid}]}.

val_next(S, _, _) ->
    S#state{count = S#state.count}.

val_post(S, _, Result) ->
    eq(Result, S#state.count).

%% property test

prop_tickets() ->
    ?FORALL(Cmds, eqc_fsm:parallel_commands(?MODULE),
            begin
                {ok, Pid} = msgcounter_gen_server:start_link(),
                % environment info given as {pid, Pid}
                % retrievable as {var, pid} replaced by Pid
                {H, S, Res} = eqc_fsm:run_parallel_commands(?MODULE, Cmds, [{pid, Pid}]),
                msgcounter_gen_server:stop(Pid),
                pretty_commands(?MODULE, Cmds, {H, S, Res},
                                aggregate(command_names(Cmds), Res == ok))
            end).
