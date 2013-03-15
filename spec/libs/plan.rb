require 'spec_helper'

describe Participant do


  it "define PLANS as a hash of plan types"

  it "should be able to contruct from an input string"

  it "should construct a 'free' plan if the input is bad"

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