module JasmineWebpacker
  class ManifestHandler
    def call(rack_env)
      path = WebpackerHelperAccessor.new.asset_pack_path('specs.js')
      [200, {"Content-Type" => "application/json"}, [JSON.generate({path: path})]]
    end
  end
end
