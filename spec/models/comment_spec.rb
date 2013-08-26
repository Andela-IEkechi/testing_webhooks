# == Schema Information
#
# Table name: comments
#
#  id              :integer          not null, primary key
#  ticket_id       :integer          not null
#  feature_id      :integer
#  sprint_id       :integer
#  assignee_id     :integer
#  status_id       :integer
#  body            :text
#  cost            :integer          default(0)
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  rendered_body   :text
#  api_key_name    :string(255)
#  commenter       :string(255)
#  git_commit_uuid :string(255)
#

require 'spec_helper'

describe Comment do

  context "has a factory that"  do
    it "should create a valid comment" do
      comment = create(:comment)
      comment.should_not be_nil
      comment.should be_valid
    end

    it "should create a valid comment with a body" do
      comment = create(:comment_with_body)
      comment.should_not be_nil
      comment.should be_valid
      comment.body.should_not be_blank
    end

    it "should create a comment with a feature only" do
      comment = create(:comment_with_feature)
      comment.feature_id.should_not be_nil
      comment.sprint_id.should be_nil
    end

    it "should create a comment with a sprint only" do
      comment = create(:comment_with_sprint)
      comment.sprint_id.should_not be_nil
      comment.feature_id.should be_nil
    end

    it "should create a comment with a feature and a sprint" do
      comment = create(:comment_with_feature_and_sprint)
      comment.feature_id.should_not be_nil
      comment.sprint_id.should_not be_nil
    end
  end

  context "validates that" do
    before(:each) do
      @comment = create(:comment)
    end

    it "should have a default cost of 0" do
      @comment.cost.should == 0
    end

    it "should be valid when cost is in #{Ticket::COST}" do
      Ticket::COST.each do |cost|
        create(:comment, :cost => cost).should_not be_nil
      end
    end

    it "must have a status" do
      @comment.status = nil
      # raise @comment.status.inspect
      @comment.should_not be_valid
    end

    it "must have either an api_key or user_id, but not both" do
      @comment.user_id.should_not be_nil
      @comment.should be_valid

      @comment.user_id = nil
      @comment.should_not be_valid

      @comment.api_key = create(:api_key)
      @comment.should be_valid
    end

    it "should have a cost assigned" do
      @comment.cost.should_not be_nil
    end
  end

  context 'contains body markup that' do
    before(:each) do
      @comment = build(:comment, :status => create(:ticket_status))
    end

    it 'can be plain text' do
      @comment.body = "plain text"
      @comment.should be_valid
    end

    it 'can be markdown flavoured text' do
      @comment.body = "#markdown text"
      @comment.should be_valid
    end

    it 'stores the parsed markdown' do
      @comment.body = "#markdown text"
      @comment.rendered_body.should be_blank
      @comment.save
      @comment.rendered_body.should_not be_blank
    end

    it 'has markdown text which is converted to HTML ' do
      @comment.body = "# markdown text #"
      @comment.save
      @comment.rendered_body.should eq('<h1>markdown text</h1>')
    end
  end

  it "is deleted when it's parent ticket is destroyed" do
    comment = create(:comment)
    expect {
      comment.ticket.destroy
    }.to change(Comment, :count).by(-1)
  end
end
