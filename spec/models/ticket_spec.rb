require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:subject) {create(:ticket)}

  it { should belong_to(:project) }
  it { should have_many(:comments) }
  it { should have_many(:split_tickets).through(:comments) }
  it { should have_and_belong_to_many(:boards) }

  it { should respond_to(:status) }
  it { should respond_to(:assignee) }
  it { should respond_to(:creator) }
  it { should respond_to(:title) }
  it { should respond_to(:split_tickets) }

  it { should validate_presence_of(:title) }

  it "enables paper trail" do
    is_expected.to be_versioned
  end  
    
  describe "delegated comment attributes" do
    describe ".assignee" do
      before(:each) do
        create(:comment, ticket: subject, assignee: create(:user))
      end

      it "is the value on the last comment" do
        #create a new comment with a different assignee
        expect {
          create(:comment, ticket: subject, assignee: create(:user))
        }.to change{subject.assignee}
      end

      it "can be nil" do
        subject.comments.clear
        expect(subject.assignee).to eq(nil)
      end
    end

    describe ".status" do
      before(:each) do
        create(:comment, ticket: subject, status: create(:status))
      end

      it "is the value on the last comment" do
        #create a new comment with a different assignee
        expect {
          create(:comment, ticket: subject, status: create(:status))
        }.to change{subject.status}
      end

      it "can be nil" do
        subject.comments.clear
        expect(subject.status).to eq(nil)
      end
    end
  end

  describe ".creator" do
    it "returns the user who logged the first comment" do
      comment = create(:comment, ticket: subject)
      assert(comment.commenter.present?, "comment must have a commenter") 
      expect(subject.creator).to eq(comment.commenter)
    end

    it "returns nil if there are no comments" do 
      assert(subject.comments.empty?, 'ticket must not have comments')
      expect(subject.creator.present?).to eq(false)
    end
  end

  describe "split_tickets" do
    before do
      comment = create(:comment, ticket: subject)
      create(:ticket, parent_id: comment.id)
      create(:ticket, parent_id: comment.id)
    end

    it "should be sorted by id in ascending order" do
      expect(subject.split_tickets.first.id).to be < subject.split_tickets.last.id
    end
  end
end
