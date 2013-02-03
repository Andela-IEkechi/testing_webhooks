require 'spec_helper'
require 'shared/examples_for_scoped'

describe Feature do
  it_behaves_like 'scoped' do
    let(:scoped_class) { Feature }
  end


  before(:each) do
    @feature = create(:feature)
  end

  it "must have a working factory" do
    @feature.should_not be_nil
  end

  it "should have a valid factory" do
    @feature.should be_valid
  end

  it "must have a title" do
    @feature.title = nil
    @feature.should_not be_valid
  end

  it "gives it's title on to_s" do
    @feature.to_s.should eq(@feature.title)
  end

  it "has an optional due date" do
    @feature.due_on = nil
    @feature.should be_valid
    @feature.due_on = Date.today + 5.days
    @feature.should be_valid
  end

  it "has an optional description" do
    @feature.description = nil
    @feature.should be_valid

    @feature.description = 'a nice description'
    @feature.should be_valid
  end

  it "must have unique title in the project" do
    dup_feature = build(:feature, :title => @feature.title, :project => @feature.project)
    dup_feature.should_not be_valid
  end

  it "can have a duplicate title across projects" do
    other_project = create(:project)
    dup_feature = create(:feature, :title => @feature.title, :project => other_project)
    @feature.title.should eq(dup_feature.title)
    dup_feature.should be_valid
  end

  it "must have a valid project" do
    @feature.project = nil
    @feature.should_not be_valid
  end

  it "should return the scoped_id when an id is implied", focus: true do
    @feature.scoped_id = @feature.project.features_sequence + 1
    @feature.id.should_not eq(@feature.scoped_id)
    @feature.to_param.should eq(@feature.scoped_id)

  end

  context "without tickets" do

    it "should have a 0 cost if there are no tickets" do
      @feature.should have(0).tickets
      @feature.cost.should eq(0)
    end

  end

  context "with tickets" do
    before(:each) do
      create(:ticket, :project => @feature.project)
      create(:ticket, :project => @feature.project)
    end

    it "should report on the assigned tickets" do
      @feature.project.tickets.each do |ticket|
        create(:comment, :feature => @feature)
      end
      @feature.reload
      @feature.assigned_tickets.count.should eq(@feature.project.tickets.count)
    end

    it "must be able to contain tickets" do
      @feature.should respond_to(:tickets)
    end

    it "must sum the costs of all the tickets in it" do
      @feature.assigned_tickets.each do |ticket|
        ticket.comments.create(:feature => @feature, :cost => 2)
      end
      @feature.cost.should eq(@feature.assigned_tickets.count * 2)
    end

    it "should not report the same ticket as assigned multiple times" do
      @feature.assigned_tickets.count.should eq(0)
      commentor = create(:user)
      bad_ticket = create(:ticket, :project => @feature.project)

      create(:comment, :ticket => bad_ticket, :feature => @feature)
      bad_ticket.should be_valid
      @feature.reload
      @feature.assigned_tickets.count.should eq(1)

      create(:comment, :ticket => bad_ticket, :feature => @feature)
      bad_ticket.should be_valid
      @feature.reload
      @feature.assigned_tickets.count.should eq(1)
    end
  end

end

