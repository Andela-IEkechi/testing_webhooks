require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:subject) {create(:member)}

  it { should belong_to(:project) }  
  it { should belong_to(:user) }

  it { should respond_to(:role) }  
  it { should validate_inclusion_of(:role).in_array(Member::ROLES) }  
end
