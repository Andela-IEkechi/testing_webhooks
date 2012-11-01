require 'spec_helper'

describe Comment do

  context "has a factory that"  do
    it "should create a valid comment" do
      comment = create(:comment)
      comment.should_not be_nil
      comment.should be_valid
    end

    it "should create a valid comment with a body" do
      comment = create(:comment_with_body)
      comment.should_not be_nil
      comment.should be_valid
      comment.body.should_not be_blank
    end
  end

  context "validates that" do
    before(:each) do
      @comment = create(:comment)
    end

    # it "should have a default cost of 0" do
    #   @comment.cost.should == 0
    # end

    it "should not have a default cost of 0" do
      @comment.cost.should_not eq(0)
    end

    it "should have a default cost of 1" do
      @comment.cost.should == 1
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

    it "should have a cost between 1 and 3" do
      (1..3).each do |l|
        @comment.cost = l
        @comment.should be_valid
      end
    end

    it "should have a cost no greater than 3" do
        @comment.cost = 4
        @comment.should_not be_valid
    end
  end

  context 'contains body markup that' do
    before(:each) do
      @comment = build(:comment, :status => create(:ticket_status))
    end

    it 'can be plain text' do
      @comment.body = "plain text"
      @comment.should be_valid
    end

    it 'can be markdown flavoured text' do
      @comment.body = "#markdown text"
      @comment.should be_valid
    end

    it 'stores the parsed parkdown' do
      @comment.body = "#markdown text"
      @comment.rendered_body.should be_blank
      @comment.save
      @comment.rendered_body.should_not be_blank
    end

    it 'has markdown text which is converted to HTML ' do
      @comment.body = "# markdown text #"
      @comment.save
      @comment.rendered_body.should eq('<h1>markdown text</h1>')
    end

  end
end
