require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:subject) {create(:board)}

  it { should belong_to(:project) }  
  it { should have_and_belong_to_many(:tickets) }  

  it { should respond_to(:name) }  

  it "enables paper trail" do
    is_expected.to be_versioned
  end  
    
end
