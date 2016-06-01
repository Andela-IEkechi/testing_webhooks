require 'rails_helper'

RSpec.describe Attachment, type: :model do
  let(:subject) {create(:attachment)}

  it { should belong_to(:comment) }
  it { should have_one(:ticket).through(:comment) }
  it { should respond_to(:file) }
  it { should respond_to(:filename) }
  it { should respond_to(:file_size) }
  it { should respond_to(:file_content_type) }

  it "enables paper trail" do
    is_expected.to be_versioned
  end

  describe ".filename" do
    it "returns the file name of an attachment" do
      expect(subject.filename).to eq(subject.file_filename)
    end
  end
end
