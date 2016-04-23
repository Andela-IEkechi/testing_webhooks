require 'rails_helper'

RSpec.describe Status, type: :model do
  let(:subject) {create(:status)}

  it { should belong_to(:project) }

  it { should respond_to(:name) }
  it { should respond_to(:order) }
  it { should respond_to(:open) }
end
