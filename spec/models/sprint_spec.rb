require 'spec_helper'

describe Sprint, :focus => true do
  before(:each) do
    @sprint = create(:sprint)
  end

  it "must have a working factory" do
    @sprint.should_not be_nil
  end

  it "must have a goal" do
    @sprint.goal = nil
    @sprint.should_not be_valid
  end

  it "must have unique goal in the project" do
    dup_sprint = build(:sprint, :goal => @sprint.goal, :project => @sprint.project)
    dup_sprint.should_not be_valid
  end

  it "can have a duplicate goal across projects" do
    other_project = create(:project)
    dup_sprint = create(:sprint, :goal => @sprint.goal, :project => other_project)
    @sprint.goal.should eq(dup_sprint.goal)
    dup_sprint.should be_valid
  end

  it "must have a valid project" do
    @sprint.project = nil
    @sprint.should_not be_valid
  end

  context "without tickets" do

    it "should have a 0 cost if there are no tickets" do
      @sprint.should have(0).tickets
      @sprint.cost.should eq(0)
    end

  end

  context "with tickets" do
    before(:each) do
      create(:ticket, :project => @sprint.project)
      create(:ticket, :project => @sprint.project)
    end

    it "should report on the assigned tickets" do
      @sprint.project.tickets.each do |ticket|
        create(:comment, :sprint => @sprint)
      end
      @sprint.reload
      @sprint.assigned_tickets.count.should eq(@sprint.project.tickets.count)
    end

    it "must be able to contain tickets" do
      @sprint.should respond_to(:tickets)
    end

    it "must sum the costs of all the tickets in it" do
      @sprint.assigned_tickets.each do |ticket|
        ticket.comments.create(:sprint => @sprint, :cost => 2)
      end
      @sprint.cost.should eq(@sprint.assigned_tickets.count * 2)
      @sprint.cost.should == @sprint.assigned_tickets.sum(&:cost)
    end

    it "should not report the same ticket as assigned multiple times" do
      @sprint.assigned_tickets.count.should eq(0)
      commentor = create(:user)
      bad_ticket = create(:ticket, :project => @sprint.project)

      create(:comment, :ticket => bad_ticket, :sprint => @sprint)
      bad_ticket.should be_valid
      @sprint.reload
      @sprint.assigned_tickets.count.should eq(1)

      create(:comment, :ticket => bad_ticket, :sprint => @sprint)
      bad_ticket.should be_valid
      @sprint.reload
      @sprint.assigned_tickets.count.should eq(1)
    end

  end
end
