require 'spec_helper'

describe Comment::Asset, focus: true do

  before(:each) do
    @asset = create(:comment_asset)
  end

  it "must have a working factory" do
    @asset.should_not be_nil

  end

  it "should belong to a comment" do
    asset_with_no_comment = build(:comment_asset_with_no_comment)
    asset_with_no_comment.should_not be_valid
    comment = create(:comment)
    asset_with_no_comment.comment = comment
    asset_with_no_comment.should be_valid
  end

  it "should have timestamps" do
    @asset.should respond_to(:created_at)
    @asset.should respond_to(:updated_at)
  end

  context "with uploaded files" do
    it "should allow us to attach one file"
  end
end
