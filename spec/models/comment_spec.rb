require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:subject) {create(:comment)}

  it { should belong_to(:ticket) }
  it { should have_many(:attachments) }
  it { should belong_to(:status) }
  it { should belong_to(:assignee) }
  it { should belong_to(:commenter) }

  it { should_not validate_presence_of(:assignee)}
  
  it { should respond_to :message}
  it { should respond_to :previous}
  it { should respond_to :tag_list}

  it "enables paper trail" do
    is_expected.to be_versioned
  end  

  # NOTE: I've removed the gems for now, this might all need to go later on.
  # it { should respond_to :html}
  # describe ".html" do
  #   it "returns parsed markdown" do
  #     subject.message = "*bold* **italics** `escaped`"
  #     sample_html = "<p><em>bold</em> <strong>italics</strong> <code class=\"prettyprint\">escaped</code></p>"
  #     expect(subject.html).to eq(sample_html)
  #   end

  #   it "deals with blank messages" do
  #     subject.message = nil
  #     sample_html = ""
  #     expect(subject.html).to eq(sample_html)
  #   end
  # end
end
