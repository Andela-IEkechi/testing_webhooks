require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:subject) {create(:ticket)}

  it { should belong_to(:project) }
  it { should have_many(:comments) }
  it { should belong_to(:parent) }
  it { should have_many(:children) }
  it { should have_and_belong_to_many(:boards) }
end
