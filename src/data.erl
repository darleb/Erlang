-module(data).

-export([init_data/1, info_data/1, add_data/3, get_product_data/0]).

-include_lib("stdlib/include/qlc.hrl").
-record(shop, {item, id, quantity, cost}).


init_data(Nodes) ->
  mnesia:create_schema(Nodes),
  mnesia:start(Nodes),
  [rpc:call(Node, mnesia, start, []) || Node <- Nodes],
  mnesia:create_table(shop, [{attributes, record_info(fields, shop)},  {type, bag}, {frag_properties, [{n_fragments, 4}, {node_pool, Nodes}]}]).

info_data(Info) ->
  F = fun(It) -> mnesia:table_info(shop, It) end,
  mnesia:activity(transaction, F, [Info], mnesia_frag).

add_data(Item, Id, Cost) ->
  Row = #shop{item=Item, id=Id, cost=Cost},
  F = fun() ->
    mnesia:write(Row)
      end,
  mnesia:activity(transaction, F, [], mnesia_frag).

get_product_data() ->
      mnesia:transaction(
              fun() ->
                  qlc:e( qlc:q(
                  [ X || X <- mnesia:table(shop)]))
              end).


