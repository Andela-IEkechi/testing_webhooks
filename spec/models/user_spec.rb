require 'rails_helper'

RSpec.describe User, type: :model do  
  let(:subject) {create(:user)}

  it { should have_and_belong_to_many(:memberships) }
  it { should have_one(:account) }

  it { should validate_uniqueness_of(:email).case_insensitive }

  it { should respond_to(:email) }
  it { should respond_to(:name) }

  it "enables paper trail" do
    is_expected.to be_versioned
  end
  
  describe ".account" do
    it "is created after the user is created" do
      expect(subject.account).not_to eq(nil)
      # having trouble testing the after_create hook to :create_account
    end
  end

end
