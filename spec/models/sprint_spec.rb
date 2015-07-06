require 'spec_helper'
require 'shared/examples_for_scoped'

describe Sprint, :type => :model, :focus => true do

  let(:subject) {create(:sprint)}
  it {expect(subject).to respond_to(:closed?)}
  it {expect(subject).to respond_to(:open?)}
  it {expect(subject).to respond_to(:assigned_tickets)}
  it {expect(subject).to respond_to(:running?)}
  it {expect(subject).to respond_to(:goal)}
  it {expect(subject).to validate_presence_of(:goal)}
  it {expect(subject).to validate_uniqueness_of(:goal).scoped_to(:project_id)}
  it {expect(subject).to validate_presence_of(:project)}

  it_behaves_like 'scoped' do
    let(:scoped_class) { Sprint }
  end

  it "orders by :goal ASC" do
    5.times {
      create(:sprint)
    }
    expect(Sprint.all.collect(&:goal)).to eq(Sprint.all.collect(&:goal).sort)
  end

  context "without tickets" do
    it "has a cost 0" do
      subject.assigned_tickets.each(&:destroy)
      subject.reload
      expect(subject.cost).to eq(0)
    end
  end

  context "with tickets" do
    before(:each) do
      ticket1 = create(:ticket, :project => subject.project)
      create(:comment, :ticket => ticket1)
      ticket2 = create(:ticket, :project => subject.project)
      create(:comment, :ticket => ticket2)
    end

    it "should report on the assigned tickets" do
      subject.project.tickets.each do |ticket|
        create(:comment, :sprint => subject)
      end
      subject.reload
      subject.assigned_tickets.count.should eq(subject.project.tickets.count)
    end

    it "must sum the costs of all the tickets in it" do
      subject.assigned_tickets.each do |ticket|
        ticket.comments.create(:sprint => subject, :cost => 2)
      end
      subject.cost.should eq(subject.assigned_tickets.count * 2)
      subject.cost.should == subject.assigned_tickets.sum(&:cost)
    end

    it "should not report the same ticket as assigned multiple times" do
      subject.assigned_tickets.count.should eq(0)
      commentor = create(:user)
      bad_ticket = create(:ticket, :project => subject.project)

      create(:comment, :ticket => bad_ticket, :sprint => subject)
      bad_ticket.should be_valid
      subject.reload
      subject.assigned_tickets.count.should eq(1)

      create(:comment, :ticket => bad_ticket, :sprint => subject)
      bad_ticket.should be_valid
      subject.reload
      subject.assigned_tickets.count.should eq(1)
    end

    it "should be open if it's still running" do
      subject.due_on = Date.today + 5
      subject.should be_open
    end

    it "should be open if it has open tickets" do
      ticket = subject.project.tickets.first
      ticket.sprint = subject
      ticket.status.open = true
      ticket.save
      subject.should be_open
    end

    it "should be closed if its not running and has no open tickets", :focus do
      subject.assigned_tickets.each do |t|
        t.sprint = nil
        t.save
      end
      ticket = subject.project.tickets.first
      ticket.sprint = subject
      ticket.save

      subject.due_on = 5.days.from_now
      #running with an open ticket!
      ticket.status.open=true
      ticket.save
      subject.reload
      subject.should_not be_closed

      #running with a closed ticket!
      ticket.status.open=false
      ticket.save
      subject.reload
      subject.should_not be_closed

      #not running with an open ticket!
      subject.due_on = 5.days.ago
      ticket.status.open=true
      ticket.save
      subject.reload
      subject.should_not be_closed

      #not running with a closed ticket!
      subject.due_on = 5.days.ago
      ticket.status.open=false
      ticket.save
      subject.reload
      subject.should be_closed
    end

    it "should be running if due date is in the future" do
      subject.due_on = Date.today - 5
      subject.should_not be_running
      subject.due_on = Date.today + 5
      subject.should be_running
    end
  end

end
