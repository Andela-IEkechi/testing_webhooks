require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:subject) {create(:ticket)}

  it { should belong_to(:project) }
  it { should have_many(:comments) }
  it { should belong_to(:parent) }
  it { should have_many(:children) }
  it { should have_and_belong_to_many(:boards) }

  it {should respond_to(:status)}
  it {should respond_to(:assignee)}
  it {should respond_to(:creator)}

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
end
