require 'rails_helper'

RSpec.describe Asset, type: :model do
  let(:subject) {create(:asset)}

  it "enables paper trail" do
    is_expected.to be_versioned
  end

  it {is_expected.to belong_to :assetable}
  it {is_expected.to responds_to :payload}

end
