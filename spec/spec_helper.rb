require "zirconia"

def load_support_files!
  Dir[File.join(__dir__, "support/**/*.rb")].each { |f| require f }
end

RSpec.configure do |config|
  load_support_files!

  Kernel.srand(config.seed)

  config.default_formatter = :doc if config.files_to_run.one?

  config.disable_monkey_patching!

  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }

  config.order = :random

  config.include TempDirHelper
  config.include FileMatchers
end
