require 'spec_helper'
require 'shared/examples_for_scoped'

describe Sprint do
  it_behaves_like 'scoped' do
    let(:scoped_class) { Sprint }
  end

  before(:each) do
    #make sure we have no users in the system, faker sometimes gets tripped up ?!
    User.all.each(&:destroy)
    @sprint = create(:sprint)
  end

  it "must have a working factory"  do

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

  it "orders by :goal ASC" do
    create(:sprint, :goal => "zzzz this should be last")
    5.times {
      create(:sprint)
    }
    Sprint.all.collect(&:goal).should eq(Sprint.all.collect(&:goal).sort)
  end

  context "without tickets" do
    it "should have a 0 cost" do
      @sprint.assigned_tickets.each(&:destroy)
      @sprint.reload
      @sprint.assigned_tickets.count.should eq(0)
      @sprint.cost.should be_zero
    end
  end

  context "with tickets" do
    before(:each) do
      ticket1 = create(:ticket, :project => @sprint.project)
      create(:comment, :ticket => ticket1)
      ticket2 = create(:ticket, :project => @sprint.project)
      create(:comment, :ticket => ticket2)
    end

    it "should report on the assigned tickets" do
      @sprint.project.tickets.each do |ticket|
        create(:comment, :sprint => @sprint)
      end
      @sprint.reload
      @sprint.assigned_tickets.count.should eq(@sprint.project.tickets.count)
    end

    it "must be able to contain tickets" do
      @sprint.should respond_to(:assigned_tickets)
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

    it "should respond to open" do
      @sprint.should respond_to(:open?)
    end

    it "should be open if it's still running" do
      @sprint.due_on = Date.today + 5
      @sprint.should be_open
    end

    it "should be open if it has open tickets" do
      ticket = @sprint.project.tickets.first
      ticket.sprint = @sprint
      ticket.status.open = true
      ticket.save
      @sprint.should be_open
    end

    it "should respond to closed" do
      @sprint.should respond_to(:closed?)
    end

    it "should be closed if its not running and has no open tickets" do
      @sprint.assigned_tickets.each do |t|
        t.sprint = nil
        t.save
      end
      ticket = @sprint.project.tickets.first
      ticket.sprint = @sprint
      ticket.save

      @sprint.due_on = 5.days.from_now
      #running with an open ticket!
      ticket.status.open=true
      ticket.save
      @sprint.reload
      @sprint.should_not be_closed

      #running with a closed ticket!
      ticket.status.open=false
      ticket.save
      @sprint.reload
      @sprint.should_not be_closed

      #not running with an open ticket!
      @sprint.due_on = 5.days.ago
      ticket.status.open=true
      ticket.save
      @sprint.reload
      @sprint.should_not be_closed

      #not running with a closed ticket!
      @sprint.due_on = 5.days.ago
      ticket.status.open=false
      ticket.save
      @sprint.reload
      @sprint.should be_closed
    end

    it "should respond to running" do
      @sprint.should respond_to(:running?)
    end

    it "should be running if due date is in the future" do
      @sprint.due_on = Date.today - 5
      @sprint.should_not be_running
      @sprint.due_on = Date.today + 5
      @sprint.should be_running
    end
  end

end
