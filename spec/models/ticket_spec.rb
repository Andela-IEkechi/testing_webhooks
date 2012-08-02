require 'spec_helper'

describe Ticket do
  before(:each) do
    @project = Project.create(:title => "example")
    @status = @project.ticket_statuses.create(:name => 'open')
    @ticket = @project.tickets.create(:title => "A testing ticket", :status => @status)

  end

  it "has an optional body" do
    @ticket.body = nil
    @ticket.should be_valid

    @ticket.body = 'a nice ticket body'
    @ticket.should be_valid
  end

  it "reports it's title on to_s" do
    @ticket.to_s.should eq(@ticket.title)
  end

  it "must have a status" do
    @ticket.status = nil
    @ticket.should_not be_valid
  end

  it "can have many comments" do
    first = @ticket.comments.create(:body => 'first comment')
    second = @ticket.comments.create(:body => 'second comment')
    @ticket.should have(2).comments
  end

  it 'should report the status of the last comment, as its own status' do
    @ticket.status.should eq(@status)
    #add a comment with an alternate status
    alternate = @project.ticket_statuses.create(:name => "alternate")
    comment = @ticket.comments.create(:status => alternate)
    @ticket.current_status.should eq(alternate)
  end

  it "should report its own status if it has no comments"  do
    @ticket.comments.delete_all
    @ticket.should have(0).comments
    @ticket.current_status.should eq(@ticket.status)
  end
end