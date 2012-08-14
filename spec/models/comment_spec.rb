require 'spec_helper'

describe Comment do

  context "has a factory that" do
    it "should create a valid comment" do
      create(:comment).should_not be_nil
    end
  end

  context "validates that" do
    before(:each) do
      @comment = create(:comment)
    end

    it "should have a default cost of 0" do
      @comment.cost.should == 0
    end

    it "should be valid when cost is in #{Ticket::COST}" do
      Ticket::COST.each do |cost|
        create(:comment, :cost => cost).should_not be_nil
      end
    end

    it "must have a status" do
      @comment.status = nil
      @comment.should_not be_valid
    end

    it "should have a cost assigned" do
      @comment.cost.should_not be_nil
    end

    it "should have a cost between 0 and 3" do
      (0..3).each do |l|
        @comment.cost = l
        @comment.should be_valid
      end
    end

    it "should have a cost no greater than 3" do
        @comment.cost = 4
        @comment.should_not be_valid
    end

  end
end
