require 'spec_helper'

describe Comment, :focus => true do 

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

    it "should create a comment with a feature only" do
      comment = create(:comment_with_feature)
      comment.feature_id.should_not be_nil
      comment.sprint_id.should be_nil
    end

    it "should create a comment with a sprint only" do
      comment = create(:comment_with_sprint)
      comment.sprint_id.should_not be_nil
      comment.feature_id.should be_nil
    end

    it "should create a comment with a feature and a sprint" do
      comment = create(:comment_with_feature_and_sprint)
      comment.feature_id.should_not be_nil
      comment.sprint_id.should_not be_nil
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
      # raise @comment.status.inspect
      @comment.should_not be_valid
    end

    # it "must have a api_key or user_id" do
    #   @comment.user_id = nil
    #   @comment.should be_valid
    #   @comment.user_id = 
    # end

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
