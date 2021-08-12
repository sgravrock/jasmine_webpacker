require 'open3'
require 'tmpdir'
require 'json'
require 'net/http'

describe 'Serving specs (integration)' do
  it "fails when used outside a Rails app"

  describe "in a Rails 6 application" do
    before(:all) do
      @original_cwd = Dir::pwd
      @gem_root_dir = File.absolute_path(File.join(__FILE__, '../../'))
      @tmpdir = Dir.mktmpdir
      Dir::chdir(@tmpdir)

      check_call ["rails", "new", "--skip-bundle", "--skip-bootsnap", "--skip-webpack-install", "."]

      open "Gemfile", "a" do |f|
        f.puts <<~END
        source "https://rubygems.org"
        gem "jasmine_webpacker", :path => "#{@gem_root_dir}"
        END
      end

      Bundler.with_unbundled_env do
        check_call ["rails", "webpacker:install"]
      end
    end

    after(:all) do
      Dir::chdir(@original_cwd)
      FileUtils.remove_entry @tmpdir
    end


    it "provides a correct URL for the 'specs' pack" do
      # TODO: use our own init command here, once we have one
      open "app/javascript/packs/specs.js", "w" do |f|
        f.puts "'the contents of all the specs';"
      end

      Bundler.with_unbundled_env do
        # TODO: remove this once jasmine-webpacker does an initial webpack build
        check_call ["bundle", "exec", "./bin/webpack"]

        begin
          # TODO: fail in an obvious way if something's already listening on 8888
          pid = IO.popen(["bundle", "exec", "jasmine-webpacker"]).pid

          manifest_response = poll_until_connected(URI.parse("http://localhost:8888/jasmine-assets"))
          expect(manifest_response.code).to eq "200"
          expect(manifest_response.header["content-type"]).to start_with "application/json"
          manifest = JSON::parse manifest_response.body
          expect(manifest["scripts"].length).to eq 1

          js_response = get_response(URI.parse(manifest["scripts"][0]))
          expect(js_response.header["content-type"]).to start_with "application/javascript"
          expect(js_response.body).to include "the contents of all the specs"
        ensure
          Process.kill :SIGTERM, pid
        end
      end
    end

    it "integrates with jasmine-browser-runner"
  end
end

def check_call(cmd)
  print "Running #{cmd.join " "}: "
  STDOUT.flush
  output, status = Open3.capture2e(*cmd)
  unless status.success?
    raise "#{cmd} failed. See output below:\n\n#{output}"
  end
end

def poll_until_connected(uri)
  deadline = Time.now + 10 # seconds
  while Time.now < deadline
    begin
      return get_response uri
    rescue Errno::ECONNREFUSED
      sleep 0.5
    end
  end

  puts "Timed out after waiting 10 seconds for jasmine-webpacker to start"
end

def get_response(uri)
  Net::HTTP.start(uri.host, uri.port) do |http|
    request = Net::HTTP::Get.new uri
    return http.request request
  end
end
