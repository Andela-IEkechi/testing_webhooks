require 'rails_helper'

RSpec.describe ApiKey, type: :model  do
  let(:subject) {create(:api_key)}

  it { should belong_to(:project) }

  it { should respond_to(:name) }
  it { should respond_to(:access_key) }

  it { should validate_presence_of(:project) }
  it { should validate_uniqueness_of(:name).scoped_to(:project_id) }
  it { should validate_uniqueness_of(:access_key) }

  describe ".generate_access_key" do
    it "is called on create" do
      project = create(:project)
      api_key = build(:api_key, :project => project)
      expect(api_key.access_key).to eq(nil)
      expect(api_key).to receive(:generate_access_key)
      api_key.save
    end

    it "sets the access_key value if it's empty" do
      subject.access_key = nil
      subject.send(:generate_access_key)
      expect(subject.access_key.present?).to eq(true) 
    end

    it "does not set the access_key value if it's present" do
      subject.access_key = "example"
      subject.send(:generate_access_key)
      expect(subject.access_key).to eq("example") 
    end
  end
end
