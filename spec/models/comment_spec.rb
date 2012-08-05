require 'spec_helper'

describe Comment do
  before(:each) do
    @project = Project.create(:title => 'example project')
    @ticket = @project.tickets.create(:title => 'example ticket', :body => 'a ticket body')
    @comment = @ticket.comments.create()
  end

  it "should belong to a ticket" do
    orphan_comment = Comment.new()
    orphan_comment.should_not be_valid

    orphan_comment.ticket = @ticket
    orphan_comment.should be_valid
  end

  it "should be filterable on the presense of status" do
    comment_one = @ticket.comments.create()
    comment_two = @ticket.comments.create(:status => @project.ticket_statuses.first)

    Comment.with_status.count.should eq(1)
    Comment.count.should eq(3)
  end
end
