require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:subject) {create(:project)}

  it { should have_many(:boards) }
  it { should have_many(:tickets) }
  it { should have_many(:statuses) }
  it { should have_and_belong_to_many(:members) }

  it { should respond_to(:name)}
  it { should respond_to(:logo)}
  it { should respond_to(:slug)}

  it "enables paper trail" do
    is_expected.to be_versioned
  end  
      
end
