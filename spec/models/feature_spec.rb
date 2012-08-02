require 'spec_helper'

describe Feature do
  before(:each) do
    @feature = Feature.new(:title => 'a test feature')
  end

  it "has an optional description" do
    @feature.description = nil
    @feature.should be_valid

    @feature.description = 'a nice description'
    @feature.should be_valid
  end

  it "gives it's title on to_s" do
    @feature.to_s.should eq(@feature.title)
  end

end