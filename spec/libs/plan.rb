require 'spec_helper'

describe Participant, :focus => true do

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

  it "should respond to :to_s with the plan name"

  it "should respond to :upgrade_to?"

  it "should respond with the next higher plan for :upgrade_to?"

  it "should respond to :downgrade_to?"

  it "should respond with the next lower plan for :downgrade_to?"

  it "should respond to :upgrade with a new plan"

  it "should respond to :downgrade with a new plan"

  it "should compare plans with :better_than?"

  it "should compare plans with :worse_than?"

end