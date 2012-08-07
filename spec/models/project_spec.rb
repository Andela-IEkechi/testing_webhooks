require 'spec_helper'

describe Project, :focus => true do
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
end