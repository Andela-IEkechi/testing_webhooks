require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:subject) {create(:account)}

  it "enables paper trail" do
    is_expected.to be_versioned
  end

  it {is_expected.to belong_to :user}

  it {is_expected.to validate_presence_of(:plan)}
  it {is_expected.to validate_inclusion_of(:plan).in_array(Account::PLANS)}

  describe "PLANS" do
    plans = ['free', 'small', 'medium', 'large']
    it "should have known values keys" do
      expect(Account::PLANS).to eq(plans)
    end
  end
end
