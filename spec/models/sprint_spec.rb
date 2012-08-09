require 'spec_helper'

describe Sprint do
  before(:each) do
    @sprint = create(:sprint)
  end

  it "must have a working factory" do
    @sprint.should_not be_nil
  end

  it "must have a title" do
    @sprint.title = nil
    @sprint.should_not be_valid
  end

  it "must have unique title in the project" do
    dup_sprint = build(:sprint, :title => @sprint.title, :project => @sprint.project)
    dup_sprint.should_not be_valid
  end

  context "with tickets" do
    before(:each) do
      create(:ticket, :project => @sprint.project)
      create(:ticket, :project => @sprint.project)
    end

    it "must be able to contain tickets" do
      @sprint.should respond_to(:tickets)
    end

    it "must sum the costs of all the tickets in it" do
      @sprint.cost.should == @sprint.tickets.sum(&:cost)
    end
  end
end
