require 'spec_helper'

describe Plan do
  let(:subject) {Plan.new(:small)}

  it "define PLANS as a hash of plan types" do
    expect(Plan::PLANS).to_not be_nil
    expect(Plan::PLANS.try(:keys)).to_not be_nil
  end

  it "should be able to contruct from an input string" do
    expect(Plan.new('free')).to_not be_nil
  end

  it "should construct a 'free' plan if the input is bad" do
    expect(Plan.new('bad argument').to_s).to eq('free')
  end

  it "should respond to :to_s with the plan name" do
    plan = subject
    expect(plan.to_s).to eq('small')
  end

  it "should respond to :upgrade_to?" do
    expect(subject).to respond_to :'upgrade_to?'
  end

  it "should respond with the next higher plan for :upgrade_to?" do
    plan = Plan.new(:free).upgrade_to?
    expect(plan).to eq('small')
  end

  it "should respond to :downgrade_to?" do
    expect(subject).to respond_to :'downgrade_to?'
  end

  it "should respond with the next lower plan for :downgrade_to?" do
    plan = subject.downgrade_to?
    expect(plan).to eq('free')
  end

  it "should respond to :upgrade with a new plan" do
    plan = subject.upgrade
    expect(plan.to_s).to eq('medium')
  end

  it "should respond to :downgrade with a new plan" do
    plan = subject.downgrade
    expect(plan.to_s).to eq('free')
  end

  it "should compare plans with :better_than?" do
    plan = Plan.new('small')
    expect(plan.better_than?('medium')).to eq(false)
    plan = Plan.new('medium')
    expect(plan.better_than?('small')).to eq(true)
  end

  it "should compare plans with :worse_than?" do
    plan = Plan.new('medium')
    expect(plan.worse_than?('small')).to eq(false)
    plan = Plan.new('small')
    expect(plan.worse_than?('medium')).to eq(true)
  end

end
