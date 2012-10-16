require 'spec_helper'

describe CommentsController, :focus => true do

  before (:each) do
    @comment = create(:comment)
  end

  describe "has a valid factory" do
    it "should have a factory" do
      @comment.should_not be_nil
    end
  end

  it "should always belong to a ticket" do
    @comment.ticket.should_not be_nil
  end

  it "should always have a body" do
    @comment = create(:comment_with_body)
    @comment.body.should_not be_nil 
  end

  it "should have 0 or more attachments"

  it "should have a creator" do
    @comment.user.should_not be_nil
  end

  context "keeps information about its ticket" do

    it "should belong to a feature" do
      @comment.feature.should_not be_nil
    end

    it "should not belong to a feature" do
      comment = create(:comment, :feature => nil)
      comment.feature.should be_nil 
    end

    it "should belong to a sprint" do
      @comment.sprint.should_not be_nil 
    end

    it "should not belong to a sprint" do
      comment = create(:comment, :sprint => nil)
      comment.sprint.should be_nil 
    end

    it "should have a cost" do
      @comment.cost.should_not be_nil
    end

    it "should hava a status" do
      @comment.status.should_not be_nil
    end

    it "should belong to an assigned user" do
      @comment = build(:comment, :assignee_id => 1)
      @comment.assignee_id.should_not be_nil
    end

    it "should not belong to an assigned user" do
      @comment.assignee_id.should be_nil
    end

  end

end
