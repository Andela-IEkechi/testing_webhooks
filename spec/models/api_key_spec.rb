require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  let(:subject) {create(:api_key)}

  it { should belong_to(:project) }

  it { should respond_to(:name) }
  it { should respond_to(:access_key) }

  it { should validate_presence_of(:project_id) }
  it { should validate_uniqueness_of(:name).scoped_to(:project_id) }
  it { should validate_uniqueness_of(:access_key) }
end
