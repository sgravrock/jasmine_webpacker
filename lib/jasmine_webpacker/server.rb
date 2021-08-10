require 'rack'

module JasmineWebpacker
  class Server
    def start
      Rack::Server.start(Port: 8888, AccessLog: [], app: Application.new)
    end
  end
end
