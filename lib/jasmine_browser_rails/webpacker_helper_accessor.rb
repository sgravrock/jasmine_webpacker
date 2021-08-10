require './config/application'

module JasmineBrowserRails
  class WebpackerHelperAccessor
    include ActionView::Helpers::AssetUrlHelper
    include Webpacker::Helper
  end
end
