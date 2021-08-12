module JasmineWebpacker
  class ManifestHandler
    def call(rack_env)
      path = WebpackerHelperAccessor.new.asset_pack_path('specs.js')
      manifest = {
        scripts: ["http://localhost:8888#{path}"]
      }
      [200, {"Content-Type" => "application/json"}, [JSON.generate(manifest)]]
    end
  end
end
