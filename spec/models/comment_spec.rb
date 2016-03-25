require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "enables paper trail" do
    is_expected.to be_versioned
  end

  it {is_expected.to belongs_to :ticket}

end
