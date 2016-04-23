require 'rails_helper'

RSpec.describe Attachment, type: :model do
  let(:subject) {create(:attachment)}

  it { should belong_to(:comment) }
  it { should respond_to(:file) }
end
