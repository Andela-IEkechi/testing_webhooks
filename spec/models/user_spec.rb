require 'rails_helper'

RSpec.describe User, type: :model do  
  #let(:subject) {create(:user)}

  it { should have_and_belong_to_many(:memberships) }
  it { should have_one(:account) }

  it { should validate_uniqueness_of(:email).case_insensitive }

  it { should respond_to(:email) }
  it { should respond_to(:name) }

  #it { should serialize(:preferences) }

  it "enables paper trail" do
    is_expected.to be_versioned
  end
  
  describe ".account" do
    let(:subject) {create(:user)}
    it "is created after the user is created" do
      expect(subject.account).not_to eq(nil)
      # having trouble testing the after_create hook to :create_account
    end
  end

  describe ".preferences" do
    it "saves the user's preferences in the database with the preferences provided " do
     attr_preference = {test1: "test1", test2: ["test1", "test2", "test2"], test3: { test1: nil, test2: [1,2,3]}}
     user = create(:user, preferences: attr_preference)
     expect(user.preferences[:test2]).to eq(attr_preference[:test2])
     expect(user.preferences[:test3][:test2]).to eq(attr_preference[:test3][:test2])
     expect(user.preferences[:test3][:test1]).to eq(nil)
    end
  end
end
