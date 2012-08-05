require 'spec_helper'

describe Ticket do
  before(:each) do
    @project = Project.create(:title => "example")
    @status = @project.ticket_statuses.create(:name => 'open')
    #@ticket = @project.tickets.create(:title => "A testing ticket", :status => @status)
    @ticket = @project.tickets.create(:title => "A testing ticket")
  end

  it "reports it's title on to_s" do
    @ticket.to_s.should eq(@ticket.title)
  end

  it "must have a status" do
    @ticket.status = nil
    @ticket.should_not be_valid
  end

  it "first comment must have ticket body" do
    body = 'ticket body as comment'
    ticket_with_body = @project.tickets.create(:title => "A testing ticket", :status => @status, :comments_attributes => [{ :body => body}])
    ticket_with_body.comments.first.body.should eq(body)
  end

  it "can have many comments" do
    first = @ticket.comments.create(:body => 'first comment')
    second = @ticket.comments.create(:body => 'second comment')
    @ticket.should have(2).comments
  end

  it 'should report the status of the last comment, as its own status' do
    @ticket.current_status.should eq(@status)
    #add a comment with an alternate status
    alternate = @project.ticket_statuses.create(:name => "alternate")
    comment = @ticket.comments.create(:status => alternate)
    @ticket.current_status.should eq(alternate)
  end
end