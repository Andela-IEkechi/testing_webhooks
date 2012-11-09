require 'spec_helper'

describe Ticket do
  before(:each) do
    @ticket = create(:ticket)
  end

  context "has a factory that" do
    it "should create a valid ticket" do
      @ticket.should_not be_nil
    end

    it "should create and invalid ticket" do
      ticket = build(:invalid_ticket)
      ticket.should_not be_valid
    end

  end

  context "validates that" do
    it "should have a title of at least 3 characters" do
      @ticket.should be_valid
      @ticket.title = 'xx'
      @ticket.should_not be_valid
    end
  end

  it "reports it's title on to_s" do
    @ticket.to_s.should eq(@ticket.title)
  end

  it "should have comments" do
    @ticket.should respond_to(:comments)
  end

  context "filter summary" do  
    it "should be present", :focus => true do
      @ticket.should respond_to :filter_summary
    end

    it "should not be empty", :focus => true do
      @ticket.filter_summary.should_not be_blank
    end

    it "should be unique", :focus => true do
      ticket1 = create(:ticket)
      ticket2 = create(:ticket, :title => ticket1.title)
      ticket1.filter_summary.should_not eq(ticket2.filter_summary)  
    end

    it "should be lower case", :focus => true do
      @ticket.title = 'UPPER CASE TITLE'
      @ticket.filter_summary.should eq(@ticket.filter_summary.downcase)
    end
  end

  context "belongs to a parent" do
    before(:each) do
      @feature = create(:feature, :project => @ticket.project)
      @sprint = create(:sprint, :project => @ticket.project)
    end

    it "the parent is a project, if there is no feature or sprint" do
      @ticket.parent.should eq(@ticket.project)
    end

    it "the parent is a feature, if there is no sprint" do
      @ticket.comments << create(:comment, :ticket => @ticket, :feature => @feature)
      @ticket.save
      @ticket.should be_valid
      @ticket.parent.should eq(@ticket.feature)
    end

    it "the parent is a sprint, if there is one" do
      @ticket.comments << create(:comment, :ticket => @ticket, :sprint => @sprint)
      @ticket.save
      @ticket.should be_valid
      @ticket.parent.should eq(@ticket.sprint)
    end

    it "it can belong to both a feature and a sprint at the same time" do
      @ticket.comments << create(:comment, :ticket => @ticket, :feature => @feature, :sprint => @sprint)
      @ticket.save

      @ticket.feature.should eq(@feature)
      @ticket.sprint.should eq(@sprint)
    end

    it "reports the id of the feature it's assigned to, or nil" do
      @ticket.feature_id.should be_nil
      @ticket.comments << create(:comment, :ticket => @ticket, :feature => @feature)
      @ticket.save
      @ticket.feature_id.should eq(@feature.id)
    end

    it "reports the id of the sprint it's assigned to, or nil" do
      @ticket.sprint_id.should be_nil
      @ticket.comments << create(:comment, :ticket => @ticket, :sprint => @sprint)
      @ticket.save
      @ticket.sprint_id.should eq(@sprint.id)
    end

  end

end