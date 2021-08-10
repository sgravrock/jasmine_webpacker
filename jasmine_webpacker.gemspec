Gem::Specification.new do |s|
  s.name        = "jasmine_webpacker"
  s.version     = "0.1.0"
  s.licenses    = ["MIT"]
  s.summary     = "Test your Rails application's JavaScript using the Jasmine testing framework"
  s.description = "Connects the jasmine-browser-runner NPM package to your " +
    "Rails application, allowing you to run Jasmine specs for its " +
    "JavaScript."
  s.authors     = ["Stephen Gravrock"]
  s.email       = "jasmine-js@googlegroups.com"
  s.homepage    = "https://jasmine.github.io"
  s.metadata    = { "source_code_uri" => "https://github.com/jasmine/jasmine_webpacker" }

  s.require_paths = ["lib"]
  s.files = `git ls-files -- {lib,bin}`.split("\n")
  s.executables = "jasmine-webpacker"

  s.required_ruby_version = ">= 2.7"
  s.add_dependency "webpacker"
  s.add_dependency "rails", ">= 6.1.3.1", "< 7.0.0"

  s.add_development_dependency "rspec", "~> 3.10"
end
