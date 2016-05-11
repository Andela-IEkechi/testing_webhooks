require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:subject) {create(:account)}

  it { should belong_to(:user) }

  it "enables paper trail" do
    is_expected.to be_versioned
  end    
end
