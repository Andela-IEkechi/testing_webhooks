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
      feature_ticket = create(:ticket_for_feature)
      feature_ticket.should_not be_nil
      feature_ticket.feature.should_not be_nil
    end

    it "should create a valid ticket belonging to a sprint" do
      sprint_ticket = create(:ticket_for_sprint)
      sprint_ticket.should_not be_nil
      sprint_ticket.sprint.should_not be_nil
    end

    it "should create a valid ticket that also sets the status" do
      @ticket.status.should_not be_nil
    end

    it "should create and invalid ticket" do
      ticket = build(:invalid_ticket)
      ticket.should_not be_valid
    end

  end

  context "validates that" do

    it "should have a default cost of 0" do
      @ticket.cost.should == 0
    end

    it "should be valid when cost is in #{Ticket::COST}" do
      Ticket::COST.each do |cost|
        create(:ticket, :cost => cost).should_not be_nil
      end
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

  end

  context "has a paper_trail that" do
    it "should not have a version if the ticket is new" do
      @ticket.should have(0).versions
    end

    it "should have a version if the ticket is updated" do
      @ticket.body = Faker::Lorem.paragraph
      @ticket.save
      @ticket.should have(1).versions
    end
  end

  it "reports it's title on to_s" do
    @ticket.to_s.should eq(@ticket.title)
  end

  it "should return the project as the parent, if there is no feature or sprint" do
    @ticket.parent.should == @ticket.project
    @ticket.should be_belongs_to_project
  end

  it "should return the feature as the parent, if there is no sprint" do
    feature_ticket = create(:ticket_for_feature)
    feature_ticket.parent.should == feature_ticket.feature
    feature_ticket.should be_belongs_to_feature
  end

  it "should not return the feature as the parent, if there is a sprint" do
    feature_ticket = create(:ticket_for_feature)
    sprint = create(:sprint, :project => feature_ticket.project)
    feature_ticket.sprint = sprint
    feature_ticket.save
    feature_ticket.parent.should_not == feature_ticket.feature
    feature_ticket.parent.should == feature_ticket.sprint
  end

  it "should return the sprint as the parent, if there is one" do
    sprint_ticket = create(:ticket_for_sprint)
    sprint_ticket.parent.should == sprint_ticket.sprint
    sprint_ticket.should be_belongs_to_sprint
  end

  it "can belong to both a feature and a sprint at the same time" do
    feature_ticket = create(:ticket_for_feature)
    sprint = create(:sprint, :project => feature_ticket.project)
    feature_ticket.sprint = sprint
    feature_ticket.save
    feature_ticket.should be_belongs_to_feature
    feature_ticket.should be_belongs_to_sprint
  end
end