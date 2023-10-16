RSpec.describe Zirconia::Application, :with_temp_dir do
  subject(:application) { described_class.new(dir:, name:) }

  let(:dir) { temp_dir }

  let(:name) { "some_gem" }

  describe "#dir" do
    it "returns a pathname" do
      expect(application.dir).to be_a(Pathname)
    end

    it "sets the expected path" do
      expect(application.dir.to_s).to eq("#{temp_dir}/#{name}")
    end
  end

  describe "#name" do
    it "returns the expected name" do
      expect(application.name).to eq(name)
    end
  end

  describe "#create!" do
    subject(:create!) { application.create! }

    let(:gem_path) { File.join(temp_dir, name) }

    let(:lib_dir)  { File.join(gem_path, "lib") }

    it "creates the gem in the specified directory" do
      expect { create! }.to create_dir(name).in(temp_dir)
    end

    it "generates a Gemfile" do
      expect { create! }.to create_file("Gemfile").in(gem_path)
    end

    it "generates a gemspec" do
      expect { create! }.to create_file("#{name}.gemspec").in(gem_path)
    end

    it "generates a lib directory" do
      expect { create! }.to create_dir("lib").in(gem_path)
    end

    it "generates a main file" do
      expect { create! }.to create_file("#{name}.rb").in(lib_dir)
    end
  end

  describe "#gem_path" do
    subject(:path) { application.gem_path(*fragments, ext:) }

    context "when no path fragments are specified" do
      let(:fragments) { [] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the root dir" do
          expect(path).to eq(application.dir)
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the root dir" do
          expect(path).to eq(application.dir)
        end
      end
    end

    context "when one path fragment is specified" do
      let(:fragments) { %w[foobar] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/foobar")
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/foobar.rb")
        end
      end
    end

    context "when multiple path fragments are specified" do
      let(:fragments) { %w[foo bar] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/foo/bar")
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/foo/bar.rb")
        end
      end
    end
  end

  describe "#lib_path" do
    subject(:path) { application.lib_path(*fragments, ext:) }

    context "when no path fragments are specified" do
      let(:fragments) { [] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the lib dir" do
          expect(path.to_s).to eq("#{application.dir}/lib")
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the lib dir" do
          expect(path.to_s).to eq("#{application.dir}/lib")
        end
      end
    end

    context "when one path fragment is specified" do
      let(:fragments) { %w[foobar] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/lib/foobar")
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/lib/foobar.rb")
        end
      end
    end

    context "when multiple path fragments are specified" do
      let(:fragments) { %w[foo bar] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/lib/foo/bar")
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/lib/foo/bar.rb")
        end
      end
    end
  end

  describe "#path" do
    subject(:path) { application.path(*fragments, ext:) }

    context "when no path fragments are specified" do
      let(:fragments) { [] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the gem dir" do
          expect(path.to_s).to eq("#{application.dir}/lib/#{name}")
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the gem dir" do
          expect(path.to_s).to eq("#{application.dir}/lib/#{name}")
        end
      end
    end

    context "when one path fragment is specified" do
      let(:fragments) { %w[foobar] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/lib/#{name}/foobar")
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/lib/#{name}/foobar.rb")
        end
      end
    end

    context "when multiple path fragments are specified" do
      let(:fragments) { %w[foo bar] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/lib/#{name}/foo/bar")
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/lib/#{name}/foo/bar.rb")
        end
      end
    end
  end

  describe "#main_file" do
    subject(:main_file) { application.main_file }

    it "returns a pathname" do
      expect(main_file).to be_a(Pathname)
    end

    it "returns the expected path" do
      expect(main_file.to_s).to eq("#{application.dir}/lib/#{name}.rb")
    end
  end

  describe "#to_sym" do
    subject(:symbol) { application.to_sym }

    it "returns a symbol" do
      expect(symbol).to be_a(Symbol)
    end

    it "returns the expected symbolised application name" do
      expect(symbol).to eq(:SomeGem)
    end
  end
end
