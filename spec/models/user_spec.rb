require 'rails_helper'

RSpec.describe User, type: :model do  
  let(:subject) {create(:user)}

  it { should have_and_belong_to_many(:memberships) }
  it { should have_one(:account) }

  it { should validate_uniqueness_of(:email).case_insensitive }

  it { should respond_to(:email) }
  it { should respond_to(:name) }

  it { should serialize(:preferences).as(Hash) }

  it "enables paper trail" do
    is_expected.to be_versioned
  end
  
  describe ".account" do
    it "is created with the user" do
      expect {
        create(:user)
      }.to change{Account.count}.by(1)
    end
  end

  describe ".preferences" do
    it "serializes the preferences" do
      attr_preferences = {test1: "test1", test2: ["test1", "test2", "test2"], test3: { test1: nil, test2: [1,2,3]}}
      user = create(:user, preferences: attr_preferences)
      user.reload #make sure we loadit up from the DB
      expect(user.preferences).to eq(attr_preferences)
    end
  end
end
