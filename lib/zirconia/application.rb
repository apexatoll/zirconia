module Zirconia
  class Application
    attr_reader :dir, :name

    def initialize(dir:, name:)
      @dir  = Pathname.new(dir).join(name)
      @name = name
    end
  end
end
