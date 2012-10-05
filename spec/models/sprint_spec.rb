require 'spec_helper'

describe Sprint, :focus => true do
  before(:each) do
    @sprint = create(:sprint)
  end

  it "must have a working factory" do
    @sprint.should_not be_nil
  end

  it "must have a title" do
    @sprint.title = nil
    @sprint.should_not be_valid
  end

  it "must have unique title in the project" do
    dup_sprint = build(:sprint, :title => @sprint.title, :project => @sprint.project)
    dup_sprint.should_not be_valid
  end

  it "can have a duplicate title across projects" do
    other_project = create(:project)
    dup_sprint = create(:sprint, :title => @sprint.title, :project => other_project)
    @sprint.title.should eq(dup_sprint.title)
    dup_sprint.should be_valid
  end

  it "must have a valid project" do
    @sprint.project = nil
    @sprint.should_not be_valid
  end

  context "with tickets" do
    before(:each) do
      create(:ticket, :project => @sprint.project)
      create(:ticket, :project => @sprint.project)
    end

    it "must be able to contain tickets" do
      @sprint.should respond_to(:tickets)
    end

    it "must sum the costs of all the tickets in it" do
      @sprint.tickets.each do |ticket|
        ticket.comments.create(:sprint => @sprint, :cost => 2)
      end
      @sprint.cost.should eq(@sprint.tickets.count * 2)
      @sprint.cost.should == @sprint.tickets.sum(&:cost)
    end

    it "should not allow the same ticket to be assigned multiple times" do
      commentor = create(:user)
      bad_ticket = create(:ticket, :project => @sprint.project)
      create(:comment, :ticket => bad_ticket, :sprint_id => @sprint.id)
      bad_ticket.should be_valid
      @sprint.should have(1).assigned_tickets
      create(:comment, :ticket => bad_ticket, :sprint_id => @sprint.id)
      bad_ticket.should be_valid
      @sprint.should have(1).assigned_tickets
    end
  end
end
