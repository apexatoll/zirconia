module Zirconia
  class Application
    attr_reader :dir, :name

    def initialize(dir:, name:)
      @dir  = Pathname.new(dir).join(name)
      @name = name
    end

    def created?
      @created == true
    end

    def create!
      `bundle gem #{dir}`

      @created = true
    end

    def load!
      require main_file.to_s
    end

    def exec(command)
      validate_gem_exists!

      Dir.chdir(dir.to_s) do
        `bundle exec #{command}`
      end
    end

    def gem_path(*fragments, ext: nil)
      build_path(*fragments, dir:, ext:)
    end

    def lib_path(*fragments, ext: :rb)
      build_path(*fragments, dir: lib_dir, ext:)
    end

    def path(*fragments, ext: :rb)
      build_path(*fragments, dir: gem_dir, ext:)
    end

    def spec_path(*fragments, ext: :rb)
      build_path(*fragments, dir: spec_dir, ext:)
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

    def spec_dir
      @spec_dir ||= dir.join("spec")
    end

    def build_path(*fragments, dir:, ext:)
      return dir if fragments.empty?

      file = fragments.pop || raise
      file = "#{file}.#{ext}" if ext

      dir.join(*fragments, file)
    end

    def validate_gem_exists!
      return if created?

      raise "gem does not exist"
    end
  end
end
