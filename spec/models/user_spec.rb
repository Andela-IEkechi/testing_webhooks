require 'spec_helper'

describe User do

  shared_examples "a project member" do
    it "that can be a member in projects"
    it "that can see all the tickets for all the projects they are members of"
  end

  context "it has factories that" do
    it "should have a working factory" do
      user = create(:user)
      user.should_not be_nil
    end

    it "should have a factory the uses a different email every time" do
      joe = create(:user)
      sue = create(:user)
      joe.email.should_not == sue.email
    end
  end

  context "when confirmed" do
    before(:each) do
      @user = create(:user)
    end

    it_behaves_like "a project member"

    it "should be able to own many projects" do
      create(:project, :user => @user)
      create(:project, :user => @user)
      @user.reload
      @user.should have(2).projects
    end

    it "should have access to all the tickets under all it's own projects" do
      project = create(:project_with_tickets, :user => @user)
      project.should have_at_least(1).tickets
      @user.reload
      @user.should have(project.tickets.count).tickets
    end

    it "should report it's email as to_s" do
      u = @user.to_s
      u.should eq(@user.to_s) 
    end
  end

  context "when not confirmed" do
    before(:each) do
      @user = create(:unconfirmed_user)
    end

    it_behaves_like "a project member"

    it "should be token authenticatable"

    it "should report it's email and (invite) as to_s" do
      u = @user.to_s
      u.should eq(@user.to_s)
    end
  end

  context "when terms not accepted" do
    it "should not allow user to be created" do
      user = build(:user_with_password)
      user.valid?
      user.should be_valid
      user.terms = "0"
      user.should_not be_valid
    end
  end

  it "should have an account when it is created" do
    user = create(:user)
    user.account.should_not be_nil
  end

  it "should have a free plan by default" do
    user = create(:user)
    user.account.plan.should eq("free")
  end
end
