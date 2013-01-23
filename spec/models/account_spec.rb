require 'spec_helper'

describe Account, focus: true do  
  it "should create a free plan of no params provided" do
    plan = create(:account)
    plan.plan.should eq "free"
  end

  it "should be enbaled by default" do
    plan = create(:account)
    p plan.inspect
    plan.enabled.should be_true
  end

  it "must return the free plan" do
    plan = create(:account, plan: "free")
    plan.plan.should eq "free"
  end

  it "must return the startup plan" do
    plan = create(:account, plan: "startup")
    plan.plan.should eq "startup"
  end

  it "must return the company plan" do
    plan = create(:account, plan: "company")
    plan.plan.should eq "company"
  end

  it "must return the organization plan" do
    plan = create(:account, plan: "organization")
    plan.plan.should eq "organization"
  end
end
