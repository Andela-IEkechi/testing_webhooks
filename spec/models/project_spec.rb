require 'spec_helper'

describe Project do
  before(:each) do
    @project = create(:project)
  end

  it "gives it's title on to_s" do
    @project.title = "A testing project"
    @project.to_s.should eq(@project.title)
  end

  it "should create default statuses of new and closed" do
    project = Project.create(:title => "with statuses")
    project.should have(2).ticket_statuses

    project.ticket_statuses.collect(&:name).include?('new').should be_true
    project.ticket_statuses.collect(&:name).include?('closed').should be_true
  end

  it "should have a unique title" do
    duplicate = build(:project, :title => @project.title)
    duplicate.should_not be_valid
  end

  pending "should have a unique name for the project owner's account"
  pending "should allow a user to have projects of the same name, for diffent owner accounts"
end