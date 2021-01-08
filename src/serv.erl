-module(serv).
-behaviour(gen_server).
-export([start_link/1, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

start_link(Nodes) -> gen_server:start_link({global, ?MODULE}, ?MODULE, [Nodes], []).

init([Nodes]) ->
  process_flag(trap_exit, false),
  [net_adm:ping(Node) || Node <- Nodes],
  data:init_data([node() | nodes()]),
  {ok, #state{}}.

handle_call({add_product, {Item, Id, Cost}}, _From, State) ->
  data:add_data(Item, Id, Cost),
  {reply, State};
handle_call({get_product}, _From, _) ->
  Res = data:get_product_data(),
  {reply, Res};
handle_call({get_all, Frag}, _From, _) ->
    Results = data:get_all(Frag),
    {reply, Results};
handle_call({info, Info}, _From, _) ->
  Res = data:info_data(Info),
  {reply, Res}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.
