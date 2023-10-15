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
end
