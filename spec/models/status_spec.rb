require 'rails_helper'

RSpec.describe Status, type: :model do
  let(:subject) {create(:status)}

  it { should belong_to(:project) }

  it { should respond_to(:name) }
  it { should respond_to(:position) }
  it { should respond_to(:open) }

  it "enables paper trail" do
    is_expected.to be_versioned
  end

end
