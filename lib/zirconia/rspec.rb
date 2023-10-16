require "tmpdir"

module Zirconia
  module RSpec
    require "zirconia/application"

    DEFAULT_NAME = "some_gem".freeze

    ::RSpec.configure do |config|
      config.around(with_gem: true) do |spec|
        self.class.class_eval { attr_reader :gem }

        name = ::RSpec.current_example.metadata[:with_gem]
        name = DEFAULT_NAME if name == true
        name = name.to_s

        Dir.mktmpdir do |dir|
          @gem = Zirconia::Application.new(dir:, name:).tap(&:create!)

          spec.run

          if Object.const_defined?(gem.to_sym)
            Object.send(:remove_const, gem.to_sym)
          end
        end
      end
    end
  end
end
