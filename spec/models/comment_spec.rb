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

  it "enables paper trail" do
    is_expected.to be_versioned
  end  

  #review notes: test that the model responds to the tags we mixed in.. something like "tag_list" or the like.

  

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


  # review notes:
  # describe ".previous" do
  #   it "returns the previous comment"
  #   it "returns nil unless there is a previous comment"
  # end


  # describe ".to_json" do
  #   it "includes the output for 'previous'"
  #   [:status_id, :assignee_id].each do |att|
  #     it "'previous' key contains #{att}"
  #   end
  # end

end
