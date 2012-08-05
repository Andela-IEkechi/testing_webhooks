require 'spec_helper'

describe Feature do
  before(:each) do
    @feature = create(:feature)
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

  it "has an optional due date" do
    @feature.due_on = nil
    @feature.should be_valid
    @feature.due_on = Date.today + 5.days
    @feature.should be_valid
  end

  it "should have a title" do
    feature_with_title = create(:feature,:title => "a feature")
    feature_with_title.should be_valid
    feature_with_title.title.should eq("a feature")
  end

  it "should have a unique title inside the project" do
    dup_feature = build(:feature, :title => @feature.title, :project => @feature.project)
    dup_feature.should_not be_valid
  end

  it "should allow dupicate titles between projects" do
    dup_feature = build(:feature, :title => @feature.title)
    dup_feature.should be_valid
  end

end