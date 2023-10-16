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
end
