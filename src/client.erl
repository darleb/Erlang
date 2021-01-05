-module(client).
-export([init_app/1, add_product/3, get_product/0, data_info/1]).


init_app(Nodes) -> serv:start_link(Nodes).

add_product(Item, Id, Cost) ->
    serv:handle_call({add_product, {Item, Id, Cost}}, self(), null),
    io:fwrite(" New product successfully added! ~n"),
    ok.

get_product() ->
    serv:handle_call({get_product}, self(), null).

data_info(Info) ->
    {reply, Response} = serv:handle_call({info, Info}, self(), null),
    io:fwrite("~p ~p ~n",[Info, Response]),
    Response.
