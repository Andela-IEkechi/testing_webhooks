require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:subject) {create(:comment)}

  it { should belong_to(:ticket) }
  it { should have_many(:attachments) }
  it { should belong_to(:status) }
  it { should belong_to(:commenter) }

  it { should respond_to :message}
end
