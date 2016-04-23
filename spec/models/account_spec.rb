require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:subject) {create(:account)}

  it { should belong_to(:user) }
end
