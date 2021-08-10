module JasmineBrowserRails
  class CLI
    def run(argv)
      puts 'Starting'
      Server.new.start
    end
  end
end
