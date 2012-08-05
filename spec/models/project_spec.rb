require 'spec_helper'

describe Project do
  before(:each) do
    @project = FactoryGirl.create(:project)
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

end