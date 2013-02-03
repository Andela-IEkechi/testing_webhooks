require 'spec_helper'

describe Account do
  before(:each) do
    @account = create(:account)
  end

  it "should create a free plan of no params provided" do
    @account.plan.should eq "free"
  end

  it "should be enbaled by default" do
    @account.enabled.should be_true
  end

  context "when specifying a plan" do
    it "must return the free plan" do
      account = create(:account, plan: "free")
      account.plan.should eq "free"
    end

    it "must return the startup plan" do
      account = create(:account, plan: "startup")
      account.plan.should eq "startup"
    end

    it "must return the company plan" do
      account = create(:account, plan: "company")
      account.plan.should eq "company"
    end

    it "must return the organization plan" do
      account = create(:account, plan: "organization")
      account.plan.should eq "organization"
    end
  end

  context "when changing plans" do
    before(:each) do
      @plans = Account::PLANS.keys
    end

    it "should know which plan to upgrade to next" do
      @account.should respond_to :'upgrade_to?'
      @plans.each_with_index do |plan, index|
        @account.plan = plan
        @account.upgrade_to?.should eq(@plans[index+1] || @plans.last)
      end
    end

    it "should know which plan to downgrade to next" do
      @account.should respond_to :'downgrade_to?'
      @plans.reverse.each_with_index do |plan, index|
        @account.plan = plan
        @account.downgrade_to?.should eq(@plans.reverse[index+1] || @plans.reverse.last)
      end
    end

    it "should be able to upgrade" do
      @plans.each_with_index do |plan, index|
        @account.plan = plan
        @account.upgrade
        @account.plan.should eq(@plans[index+1] || @plans.last)
      end
    end

    it "should be able to downgrade" do
      @plans.reverse.each_with_index do |plan, index|
        @account.plan = plan
        @account.downgrade
        @account.plan.should eq(@plans.reverse[index+1] || @plans.reverse.last)
      end
    end
  end
end
