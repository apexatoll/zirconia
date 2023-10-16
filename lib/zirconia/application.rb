module Zirconia
  class Application
    attr_reader :dir, :name

    def initialize(dir:, name:)
      @dir  = Pathname.new(dir).join(name)
      @name = name
    end

    def create!
      `bundle gem #{dir}`
    end

    def gem_path(*, ext: nil)
      build_path(*, dir:, ext:)
    end

    def lib_path(*, ext: :rb)
      build_path(*, dir: lib_dir, ext:)
    end

    def path(*, ext: :rb)
      build_path(*, dir: gem_dir, ext:)
    end

    def main_file
      @main_file ||= lib_path(name, ext: :rb)
    end

    def to_sym
      name.split("_").map(&:capitalize).join.to_sym
    end

    private

    def lib_dir
      @lib_dir ||= dir.join("lib")
    end

    def gem_dir
      @gem_dir ||= lib_dir.join(name)
    end

    def build_path(*fragments, dir:, ext:)
      return dir if fragments.empty?

      file = fragments.pop || raise
      file = "#{file}.#{ext}" if ext

      dir.join(*fragments, file)
    end
  end
end
