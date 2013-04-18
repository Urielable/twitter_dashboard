require 'sinatra'
require 'sinatra-websocket'
require 'json'

set :server, 'thin'
set :sockets, []

get '/' do
  request.websocket do |ws|
    ws.onopen do
      settings.sockets << ws
    end
    ws.onmessage do |msg|
      EM.next_tick { settings.sockets.each{ |s| s.send msg } }
    end
    ws.onclose do
      warn("wetbsocket closed")
      settings.sockets.delete(ws)
    end
  end
end
