require 'spec_helper'

describe TicketStatus do
  before(:each) do
    @project = Project.create(:title => "example")
    @open_status = @project.ticket_statuses.create(:name => "open")
    @closed_status = @project.ticket_statuses.create(:name => "closed")
  end

  it "belongs to a project" do
    orphan_status = TicketStatus.new(:name => 'orphan')
    orphan_status.should_not be_valid
  end

  it "should be unique per project" do
    duplicate = @project.ticket_statuses.build(:name => @closed_status.name)
    duplicate.should_not be_valid
    duplicate.name = "something else"
    duplicate.should be_valid
  end

  it "should have a name" do
    nameless_status = @project.ticket_statuses.build()
    nameless_status.should_not be_valid
    nameless_status.name = "something"
    nameless_status.should be_valid
  end

  it "responds with it's name for to_s" do
    @closed_status.to_s.should eq(@closed_status.name)
  end
end
