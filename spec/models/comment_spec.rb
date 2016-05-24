require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:ticket) { create(:ticket) }
  let!(:subject) { create(:comment, ticket: ticket) }

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

  describe ".previous" do
    it "returns the previous comment" do
      comment = create(:comment, ticket: ticket)
      expect(comment.previous).to eq(subject)
    end
    
    it "returns nil unless there is a previous comment" do
      expect(subject.previous).to eq(nil)
    end
  end

  describe ".to_json" do
    it "includes the output for '.previous'" do
      comment = create(:comment, ticket: ticket)
      expect(JSON.parse(comment.to_json)).to have_key("previous")
    end

    ["status_id", "assignee_id", "tag_list"].each do |att|
      it "'previous' key contains #{att}" do
        comment = create(:comment, ticket: ticket)
        expect(JSON.parse(comment.to_json)["previous"]).to have_key(att)
      end
    end
  end

  describe ".tag_list" do
    it "returns the tags on a comment" do
      comment = create(:comment, ticket: ticket, tag_list: ["testing, tags"])
      expect(comment.tag_list).to eq(["testing", "tags"])
    end
  end

end
