require_relative "lib/zirconia/version"

Gem::Specification.new do |spec|
  spec.name = "zirconia"
  spec.version = Zirconia::VERSION
  spec.authors = ["Chris Welham"]
  spec.email = ["71787007+apexatoll@users.noreply.github.com"]

  spec.summary = "An interface for creating fake gems for testing purposes"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://gem.fly.dev"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|spec)/|\.(?:git))})
    end
  end

  spec.require_paths = ["lib"]
end
