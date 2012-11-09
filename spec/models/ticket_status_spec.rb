require 'spec_helper'

describe TicketStatus do
  before(:each) do
    @status = create(:ticket_status)
  end

  it "should have a working factory" do
    @status.should_not be_nil
  end

  it "belongs to a project" do
    @status.project = nil
    @status.should_not be_valid
  end

  it "should have a name" do
    @status.name = nil
    @status.should_not be_valid
    @status.name = "something"
    @status.should be_valid
  end

  it "should have a unique name in it's project" do
    duplicate = build(:ticket_status, :project =>@status.project, :name => @status.name)
    duplicate.should_not be_valid
    duplicate.name = "something else"
    duplicate.should be_valid
  end

  it "responds with it's name for to_s" do
    @status.to_s.should eq(@status.name)
  end

  it "should respond to :open", :focus => true do
    @status.should respond_to :open
  end

  it "should be closable", :focus => true do
    @status.open.should eq(true)
    @status.close!
    @status.open.should eq(false)
  end

  it "should be openable", :focus => true do
    @status.open = false
    @status.open.should eq(false)
    @status.open!
    @status.open.should eq(true)
  end

  it "should know about tickets that use it" do
    @status.should have(0).tickets
    create(:ticket, :status => @status)
    @status.reload
    @status.should have(1).tickets
  end

  it "should not be deleted if it is in use" do
    @status.should have(0).tickets
    create(:ticket, :status => @status)
    @status.reload
    @status.should have(1).tickets
    expect {
      @status.destroy
    }.to change(TicketStatus, :count).by(0)
    expect {
      @status.tickets.find_each(&:destroy)
      @status.destroy
    }.to change(TicketStatus, :count).by(-1)
  end
end
