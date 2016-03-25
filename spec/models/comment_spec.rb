require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:subject) {create(:comment)}

  it "enables paper trail" do
    is_expected.to be_versioned
  end

  it {is_expected.to belong_to :ticket}
  it {is_expected.to belong_to :user}
  it {is_expected.to have_many(:documents).dependent(:destroy)}
  it {is_expected.to belong_to :assignee}
  it {is_expected.to belong_to :status}
  it {is_expected.to belong_to :board}
  it {is_expected.to have_many :tickets}

  it {is_expected.to validate_presence_of(:ticket).with_message("must exist")}
  it {is_expected.to validate_presence_of(:cost)}
  it {is_expected.to validate_inclusion_of(:cost).in_array(Comment::COSTS.values)}

  describe ".last" do
    it "defaults to true on a new record" do
      expect(Comment.new.last).to eq(true)
    end
  end

  describe ".set_last_comment" do
    it "sets all the comments on the ticket, except the last one, to :last = false" do
      #create some comments
      ticket = create(:ticket_with_comments)
      expect(ticket.comments.where(last: true)).to have_exactly(1).match
    end

    it "is called :after_create" do
      subject = build(:comment)
      expect(subject).to receive(:set_last_comment)
      subject.save
    end

    it "is called :after_destroy" do
      subject = create(:comment)
      expect(subject).to receive(:set_last_comment)
      subject.destroy
    end

    it "calls Ticket#set_last_comment!" do
      subject = build(:comment)
      expect(subject.ticket).to receive(:set_last_comment!)
      subject.save
    end
  end

  describe "COSTS" do
    cost = {
      "unknown": 0,
      "low": 1,
      "moderate": 2,
      "high": 3,
      "very high": 99
    }
    it "should have descriptive keys" do
      expect(Comment::COSTS.keys).to eq(cost.keys)
    end
  end
end
