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

  end

end