require 'spec_helper'

describe Ticket do
  before(:each) do
    @project = Project.create(:title => "example")
    @status = @project.ticket_statuses.create(:name => 'open')
    @ticket = @project.tickets.create(:title => "A testing ticket", :status_id => @status)

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
end