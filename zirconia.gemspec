require_relative "lib/zirconia/version"

Gem::Specification.new do |spec|
  spec.name = "zirconia"
  spec.version = Zirconia::VERSION
  spec.authors = ["Chris Welham"]
  spec.email = ["71787007+apexatoll@users.noreply.github.com"]

  spec.summary = "Lightweight testing utility for synthesising Ruby gems"

  spec.description = <<~DESCRIPTION
    Zirconia is a lightweight testing utility that is capable of generating \
    temporary Ruby Gem applications from within the test suite.

    Zirconia offers an intuitive interface around the synthetic gem allowing \
    them to be configured and coded from within the test environment.
  DESCRIPTION

  spec.homepage = "https://github.com/apexatoll/zirconia"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|spec)/|\.(?:git))})
    end
  end

  spec.require_paths = ["lib"]
end
