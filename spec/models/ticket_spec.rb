require 'spec_helper'
require 'shared/examples_for_scoped'

describe Ticket do
  it_behaves_like 'scoped' do
    let(:scoped_class) { Ticket }
  end

  before(:each) do
    @ticket = create(:ticket)
  end

  context "has a factory that" do
    it "should create a valid ticket" do
      @ticket.should_not be_nil
    end

    it "should create and invalid ticket" do
      ticket = build(:invalid_ticket)
      ticket.should_not be_valid
    end
  end

  context "validates that" do
    it "should have a title of at least 3 characters" do
      @ticket.should be_valid
      @ticket.title = 'xx'
      @ticket.should_not be_valid
    end
  end

  it "reports it's title on to_s" do
    @ticket.to_s.should eq(@ticket.title)
  end

  it "should have comments" do
    @ticket.should respond_to(:comments)
  end

  it "should return it's comments ordered by created_at", focus: true do
    @ticket.comments << create(:comment, :ticket => @ticket, :created_at => 3.days.ago)
    @ticket.comments << create(:comment, :ticket => @ticket, :created_at => 2.days.ago)
    @ticket.comments << create(:comment, :ticket => @ticket, :created_at => 4.days.ago)
    @ticket.reload
    @ticket.comments.first.created_at.to_s.should eq(4.days.ago.to_s)
    @ticket.comments.last.created_at.to_s.should eq(2.days.ago.to_s)
    @ticket.last_comment.created_at.to_s.should eq(2.days.ago.to_s)
  end

  context "last_comment" do
    before(:each) do
      @sprint = create(:sprint, :project => @ticket.project)
      @feature = create(:feature, :project => @ticket.project)
      @comment = create(:comment, :ticket => @ticket)
      @ticket.reload
    end

    it "should return the sprint and feature ids set in the last comment" do
      @ticket.sprint_id.should be_nil
      @ticket.feature_id.should be_nil

      create(:comment, :ticket => @ticket, :sprint => @sprint, :feature => @feature)
      @ticket.sprint_id.should eq(@sprint.id)
      @ticket.feature_id.should eq(@feature.id)
    end

    it "should update the last_comment association when a new comment is added" do
      @ticket.last_comment_id.should eq(@ticket.comments.last.id)
      new_comment = create(:comment, :ticket => @ticket, :sprint => @sprint, :feature => @feature)
      @ticket.last_comment_id.should eq(@ticket.comments.last.id)
      @ticket.last_comment_id.should eq(new_comment.id)
    end

    it "should update the last_comment association when a comment is removed" do
      new_comment = create(:comment, :ticket => @ticket, :sprint => @sprint, :feature => @feature)
      @ticket.last_comment_id.should eq(new_comment.id)
      @ticket.last_comment.destroy
      @ticket.reload
      @ticket.last_comment_id.should eq(@ticket.comments.last.id)
      @ticket.last_comment_id.should eq(@comment.id)
    end
  end

  it "should respond to :sprint_id" do
    @ticket.should respond_to(:sprint_id)
  end

  it "should respond to :feature_id" do
    @ticket.should respond_to(:feature_id)
  end

  context "filter summary" do
    it "should be present" do
      @ticket.should respond_to :filter_summary
    end

    it "should not be empty" do
      @ticket.filter_summary.should_not be_blank
    end

    it "should be unique" do
      ticket1 = create(:ticket)
      ticket2 = create(:ticket, :title => ticket1.title)
      ticket1.filter_summary.should_not eq(ticket2.filter_summary)
    end

    it "should be lower case" do
      @ticket.title = 'UPPER CASE TITLE'
      @ticket.filter_summary.should eq(@ticket.filter_summary.downcase)
    end
  end

  context "belongs to a parent" do
    it "the parent is a project, if there is no feature or sprint" do
      @ticket.parent.should eq(@ticket.project)
    end

    it "the parent is a feature, if there is no sprint" do
      @ticket.sprint.should be_nil
      @ticket.comments << create(:comment_with_feature, :ticket => @ticket)
      @ticket.should be_valid
      @ticket.feature.should_not be_nil
      @ticket.parent.should eq(@ticket.feature)
    end

    it "the parent is a sprint, if there is one" do
      @ticket.sprint.should be_nil
      @ticket.comments << create(:comment_with_sprint, :ticket => @ticket)
      @ticket.should be_valid
      @ticket.parent.should eq(@ticket.sprint)
    end

    it "it can belong to both a feature and a sprint at the same time" do
      @ticket.comments << create(:comment_with_feature_and_sprint, :ticket => @ticket)
      @ticket.feature.should_not be_nil
      @ticket.sprint.should_not be_nil
    end

    it "reports the id of the feature it's assigned to, or nil" do
      @ticket.feature.should be_nil
      @ticket.comments << create(:comment_with_feature, :ticket => @ticket)
      @ticket.feature.should_not be_nil
    end

    it "reports the id of the sprint it's assigned to, or nil" do
      @ticket.sprint.should be_nil
      @ticket.comments << create(:comment_with_sprint, :ticket => @ticket)
      @ticket.sprint.should_not be_nil
    end
  end
end