require './config/application'

module JasmineWebpacker
  class WebpackerHelperAccessor
    include ActionView::Helpers::AssetUrlHelper
    include Webpacker::Helper
  end
end
