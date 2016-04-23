require 'rails_helper'

RSpec.describe User, type: :model do  
  let(:subject) {create(:user)}

  it { should have_and_belong_to_many(:memberships) }

  it { should validate_uniqueness_of(:email).case_insensitive }

  it { should respond_to(:email) }
  it { should respond_to(:name) }

end
