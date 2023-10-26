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

    it "sets the created flag to true" do
      expect { create! }
        .to change { application.created? }
        .from(false)
        .to(true)
    end
  end

  describe "#load!" do
    subject(:load!) { application.load! }

    before { application.create! }

    after do
      Object.send(:remove_const, :SomeGem) if Object.const_defined?(:SomeGem)
    end

    it "loads the gem" do
      expect { load! }
        .to change { Object.const_defined?(:SomeGem) }
        .from(false)
        .to(true)
    end
  end

  describe "#exec" do
    subject(:exec) { application.exec(command) }

    context "and application does not exist" do
      let(:command) { "foobar" }

      it "raises an error" do
        expect { exec }.to raise_error("gem does not exist")
      end
    end

    context "and application exists" do
      before do
        application.create!

        failing_spec.write(<<~RUBY)
          RSpec.describe do
            it "fails" do
              expect(true).to be(false)
            end
          end
        RUBY

        passing_spec.write(<<~RUBY)
          RSpec.describe do
            it "passes" do
              expect(true).to be(true)
            end
          end
        RUBY
      end

      let(:failing_spec) do
        application.spec_path("failing_spec")
      end

      let(:passing_spec) do
        application.spec_path("passing_spec")
      end

      context "and command exits with 1" do
        let(:command) { "rspec #{failing_spec}" }

        it "does not raise any errors" do
          expect { exec }.not_to raise_error
        end

        it "returns the output string" do
          expect(exec).to be_a(String)
        end

        it "returns the expect output" do
          expect(exec).to match(/FAILED/)
        end
      end

      context "and command exits with 0" do
        let(:command) { "rspec #{passing_spec}" }

        it "does not raise any errors" do
          expect { exec }.not_to raise_error
        end

        it "returns the output string" do
          expect(exec).to be_a(String)
        end

        it "returns the expect output" do
          expect(exec).to match(/1 example, 0 failures/)
        end
      end
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

  describe "#spec_path" do
    subject(:path) { application.spec_path(*fragments, ext:) }

    context "when no path fragments are specified" do
      let(:fragments) { [] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the spec dir" do
          expect(path.to_s).to eq("#{application.dir}/spec")
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the spec dir" do
          expect(path.to_s).to eq("#{application.dir}/spec")
        end
      end
    end

    context "when one path fragment is specified" do
      let(:fragments) { %w[foobar_spec] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/spec/foobar_spec")
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/spec/foobar_spec.rb")
        end
      end
    end

    context "when multiple path fragments are specified" do
      let(:fragments) { %w[foo bar_spec] }

      context "and extension is not specified" do
        let(:ext) { nil }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/spec/foo/bar_spec")
        end
      end

      context "and extension is specified" do
        let(:ext) { :rb }

        it "returns a pathname" do
          expect(path).to be_a(Pathname)
        end

        it "returns the expected path" do
          expect(path.to_s).to eq("#{application.dir}/spec/foo/bar_spec.rb")
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
