require 'spec_helper'

describe Project do
  before(:each) do
    @project = Project.new()
  end

  it "gives it's title on to_s" do
    @project.title = "A testing project"
    @project.to_s.should eq(@project.title)
  end
end