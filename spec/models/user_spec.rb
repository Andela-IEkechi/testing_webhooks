require 'spec_helper'

describe User do

  it "should have a working factory" do
    user = create(:user)
    user.should_not be_nil
  end

  it "should have a factory the uses a different email every time" do
    joe = create(:user)
    sue = create(:user)
    joe.email.should_not == sue.email
  end

  context "when confirmed" do
    before(:each) do
      @user = create(:user)
    end
    it "should be able to have many projects" do
      create(:project, :user => @user)
      create(:project, :user => @user)
      @user.reload
      @user.should have(2).projects
    end

    it "should have access to all the tickets under all it's projects" do
      project = create(:project_with_tickets, :user => @user)
      project.should have_at_least(1).tickets
      @user.reload
      @user.should have(project.tickets.count).tickets
    end
  end
end
