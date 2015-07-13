-module(msgcounter_gen_server).

-compile({parse_transform,eqc_cover}).
-compile(export_all).

-behaviour(gen_server).

-export([start_link/0, init/1,
         inc/1, dec/1, zero/1, val/1, stop/1,
         handle_call/3, terminate/2,
         handle_cast/2, handle_info/2, code_change/3]).
-record(state, {counter = 0}).

-spec start_link() -> {ok, pid()}.
start_link() ->
    gen_server:start_link(?MODULE, [], []).

-spec inc(pid()) -> integer().
inc(Pid) ->
    gen_server:call(Pid, inc).

-spec dec(pid()) -> integer().
dec(Pid) ->
    gen_server:call(Pid, dec).

-spec zero(pid()) -> ok.
zero(Pid) ->
    gen_server:call(Pid, zero).

-spec val(pid()) -> integer().
val(Pid) ->
    gen_server:call(Pid, val).

-spec stop(pid()) -> ok.
stop(Pid) ->
    gen_server:call(Pid, terminate).

-spec init([]) -> {ok, #state{}}.
init([]) ->
    {ok, #state{counter = 0}}.

-spec handle_call(term(), pid(), #state{}) -> term().

handle_call(inc, _From, #state{counter = Count}) ->
    {reply, Count + 1, #state{counter = Count + 1}};
handle_call(dec, _From, #state{counter = Count}) ->
    {reply, Count - 1, #state{counter = Count - 1}};
handle_call(zero, _From, _S) ->
    {reply, ok, #state{counter = 0}};
handle_call(val, _From, S = #state{counter = Count}) ->
    {reply, Count, S};
handle_call(terminate, _From, S) ->
    {stop, normal, ok, S}.

-spec terminate(normal, #state{}) -> ok.
terminate(normal, _S) -> ok.

-spec handle_cast(term(), #state{}) -> term().
handle_cast(_Msg, S) -> {noreply, S}.

-spec handle_info(term(), #state{}) -> term().
handle_info(_Info, S) -> {noreply, S}.

-spec code_change(term(), #state{}, term()) -> {ok, #state{}}.
code_change(_OldVsn, S, _Extra) -> {ok, S}.
