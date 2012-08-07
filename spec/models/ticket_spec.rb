require 'spec_helper'

describe Ticket do
  before(:each) do
    @ticket = create(:ticket)
  end

  context "has factories that" do
    it "should create a valid ticket" do
      @ticket.status.should_not be_nil
    end

    it "should create a valid ticket belonging to a feature" do
      feature_ticket= create(:ticket_for_feature)
      feature_ticket.should_not be_nil
      feature_ticket.feature.should_not be_nil
    end

    it "should create a valid ticket that also sets the status" do
      @ticket.status.should_not be_nil
    end

    it "should create and invalid ticket" do
      ticket = build(:invalid_ticket)
      ticket.should_not be_valid
    end
  end

  it "reports it's title on to_s" do
    @ticket.to_s.should eq(@ticket.title)
  end

  it "should have a title of at least 3 characters" do
    @ticket.should be_valid
    @ticket.title = 'xx'
    @ticket.should_not be_valid
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

  it "should delete related comments when it's destroyed" do
    expect {
      create(:comment, :ticket => @ticket)
      create(:comment, :ticket => @ticket)
    }.to change(Comment, :count).by(2)
    expect {
      @ticket.destroy
    }.to change(Comment,:count).by(-2)
  end

  it 'should report the status of the last comment, as its own status' do
    alt_status = create(:ticket_status, :project => @ticket.project)
    create(:comment, :status => alt_status, :ticket => @ticket)
    @ticket.reload
    @ticket.current_status.should eq(alt_status)
  end

  it "should have a cost assigned" do
    @ticket.cost.should_not be_nil
  end

  it "should have a cost between 0 and 3" do
    (0..3).each do |l|
      @ticket.cost = l
      @ticket.should be_valid
    end
  end

  it "should have a cost no greater than 3" do
      @ticket.cost = 4
      @ticket.should_not be_valid
  end

  it "should return the project as the parent, if there is no feature" do
    @ticket.parent.should == @ticket.project
  end

  it "should return the feature as the parent, if there is one" do
    feature_ticket = create(:ticket_for_feature)
    feature_ticket.parent.should == feature_ticket.feature
  end
end