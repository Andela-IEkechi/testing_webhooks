require 'spec_helper'

describe Plan do

  it "define PLANS as a hash of plan types" do
    Plan::PLANS.should_not be_nil
    Plan::PLANS.try(:keys).should_not be_nil
  end

  it "should be able to contruct from an input string" do
    defined?(Plan.new('free')).should_not be_nil
  end

  it "should construct a 'free' plan if the input is bad" do
    Plan.new('bad argument').to_s.should eq('free')
  end

  it "should respond to :to_s with the plan name" do
    plan = Plan.new(:small)
    plan.to_s.should eq('small')
  end

  it "should respond to :upgrade_to?" do
    Plan.new(:small).should respond_to :'upgrade_to?'
  end

  it "should respond with the next higher plan for :upgrade_to?" do
    plan = Plan.new(:free).upgrade_to?
    plan.should eq('small')
  end

  it "should respond to :downgrade_to?" do
    Plan.new(:small).should respond_to :'downgrade_to?'
  end

  it "should respond with the next lower plan for :downgrade_to?" do
    plan = Plan.new(:small).downgrade_to?
    plan.should eq('free')
  end

  it "should respond to :upgrade with a new plan" do
    plan = Plan.new(:small).upgrade
    plan.to_s.should eq('medium')
  end

  it "should respond to :downgrade with a new plan" do
    plan = Plan.new(:small).downgrade
    plan.to_s.should eq('free')
  end

  it "should compare plans with :better_than?" do
    plan = Plan.new('small')
    plan.better_than?('medium').should be_false
    plan = Plan.new('medium')
    plan.better_than?('small').should be_true
  end

  it "should compare plans with :worse_than?" do
    plan = Plan.new('medium')
    plan.worse_than?('small').should be_false
    plan = Plan.new('small')
    plan.worse_than?('medium').should be_true
  end

end