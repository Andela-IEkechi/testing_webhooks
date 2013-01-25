require 'spec_helper'

describe Project do
  before(:each) do
    @project = create(:project)
  end

  it "should have a working factory" do
    create(:project).should_not be_nil
  end

  it "should have a working factory that adds tickets" do
    project_with_tickets = create(:project_with_tickets)
    project_with_tickets.should_not be_nil
    project_with_tickets.should have_at_least(1).tickets
  end

  it "gives it's title on to_s" do
    @project.title = "A testing project"
    @project.to_s.should eq(@project.title)
  end

  it "should create default statuses of new and closed" do
    project = create(:project, :title => "with statuses")
    project.should have(2).ticket_statuses

    project.ticket_statuses.collect(&:name).include?('new').should be_true
    project.ticket_statuses.collect(&:name).include?('closed').should be_true
  end

  it "should have an owner" do
    project = create(:project)
    project.user.should_not be_nil
  end

  it "should have a sprint duration" do
      project = create(:project)
      project.sprint_duration.should_not be_nil
  end

  it "should not allow duplicate titles for the same user" do
    joe = create(:user)
    project_one = create(:project, :user => joe)
    project_one.should_not be_nil
    #now create the duplicate name
    duplicate = build(:project, :user => joe, :title => project_one.title)
    duplicate.should_not be_valid
    duplicate.title = 'something else entirely'
    duplicate.should be_valid
  end

  it "should allow duplicate titles for different users" do
    joe = create(:user)
    sue = create(:user)
    project_one = create(:project, :user => joe)
    project_one.should_not be_nil
    #now create the duplicate name but for the other user
    duplicate = build(:project, :user => sue, :title => project_one.title)
    duplicate.should be_valid
  end

  it "should delete related features when it's destroyed" do
    expect {
      create(:feature, :project => @project)
      create(:feature, :project => @project)
    }.to change(Feature, :count).by(2)
    expect {
      @project.destroy
    }.to change(Feature,:count).by(-2)
  end

  it "should delete related tickets when it's destroyed" do
    expect {
      create(:ticket, :project => @project)
      create(:ticket, :project => @project)
    }.to change(Ticket, :count).by(2)
    expect {
      @project.destroy
    }.to change(Ticket,:count).by(-2)
  end

  it "should delete related sprints when it's destroyed" do
    expect {
      create(:sprint, :project => @project)
      create(:sprint, :project => @project)
    }.to change(Sprint, :count).by(2)
    expect {
      @project.destroy
    }.to change(Sprint,:count).by(-2)
  end

  it "should delete related ticket_statuses when it's destroyed" do
    @project.should have_at_least(1).ticket_statuses
    expect {
      @project.destroy
    }.to change(TicketStatus,:count).by(-2) #two default statuses
  end

  it "should have optional API keys to allow external parties to interface with it", focus: true do
    @project.api_keys.should have(0).entries
    expect {
      @project.api_keys << create(:api_key, :project => @project, :name => "foo")
      @project.api_keys << create(:api_key, :project => @project, :name => "bar")
    }.to change{@project.api_keys}.from(0).to(2)
  end

  it "should not have an API key by default" do
    @project.should have(0).api_keys
  end

  context "with participants" do
    it "should have the project owner as a participant" do
      @project.participants.should have(1).participant
      @project.participants.first.id.should eq(@project.user.id)
    end

    it "should allow multiple participants" do
      @project.participants << create(:user)
      @project.participants << create(:user)
      @project.participants.should have(3).participants
    end

    it "should sort participants by email ASC" do
      ##NOTE, the :order directive on project.participants seems to have no effect!
      4.times do
        @project.participants << create(:user)
      end
      participant_emails = @project.ordered_participants.collect(&:email)
      ordered_emails = @project.participants.all.sort{|a,b| a.email <=> b.email}.collect(&:email)
      participant_emails.should == ordered_emails
    end
  end

  context "with tickets" do
    before(:each) do
      10.times do
        title = [*('A'..'Z')].sample(8).join
        @project.tickets.create(:title => title)
      end
    end

    it "should return tickets ordered by id" do
      ids = @project.tickets.collect(&:id)
      ids.should eq(ids.sort)
    end

    it "should not return tickets by creation date" do
      first = @project.tickets.first
      first.created_at = Time.now
      first.save

      ids = @project.tickets.collect(&:id)
      ids.should eq(ids.sort)
    end
  end
end

