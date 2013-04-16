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

  context "when changing plans", :focus => true do
    it "should respond to :upgrade" do
      @account.should respond_to :upgrade
    end

    it "should respond to :downgrade" do
      @account.should respond_to :downgrade
    end

    it "should be able to upgrade" do
      if !(@account.plan == 'large')
        expect {
          @account.upgrade
        }.to change(@account, :plan)
      end
    end

    it "should be able to downgrade" do
      if !(@account.plan == 'free')
        expect {
          @account.downgrade
        }.to change(@account, :plan)
      end
    end

  end
end
