require 'rack'

module JasmineWebpacker
  class Server
    def start
      Rack::Server.start(Port: 8888, AccessLog: [], app: builder)
    end

    def builder
      builder = Rack::Builder.new
      builder.use(
        Rack::Static,
        urls: ['/packs'],
        root: Rails.application.paths['public'].first
      )
      manifest_handler = ManifestHandler.new
      builder.map('/jasmine-assets') { run manifest_handler }
      builder
    end
  end
end
