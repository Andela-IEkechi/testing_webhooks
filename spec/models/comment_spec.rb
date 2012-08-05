require 'spec_helper'

describe Comment do
  before(:each) do
    @comment = create(:comment)
  end

  it "should have have a working factory" do
    @comment.should be_valid
  end

  it "should have a factory that creates a comment with a status" do
    comment_status = create(:comment_with_status)
    comment_status.should_not be_nil
    comment_status.status.should_not be_nil
  end

  it "should belong to a ticket" do
    @comment.ticket = nil
    @comment.should_not be_valid
  end

  it "should filter on the presense of status" do
    comment_status = create(:comment_with_status)
    Comment.with_status.count.should eq(1)
    Comment.count.should eq(2)
  end
end
