require 'spec_helper'

describe Ticket do
  before(:each) do
    @ticket = Ticket.new()
    @ticket.title = "A testing ticket"
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
end