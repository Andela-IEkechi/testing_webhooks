# == Schema Information
#
# Table name: comment_assets
#
#  id         :integer          not null, primary key
#  comment_id :integer          not null
#  payload    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Comment::Asset do

  before(:each) do
    @asset = create(:comment_asset)
  end

  it "must have a working factory" do
    @asset.should_not be_nil

  end

  #we cant test this, because we explicitly allow new assets to have no comments, refer to the asset model class for detials
  # it "should belong to a comment" do
  #   asset_with_no_comment = build(:comment_asset_with_no_comment)
  #   asset_with_no_comment.should_not be_valid
  #   comment = create(:comment)
  #   asset_with_no_comment.comment = comment
  #   asset_with_no_comment.should be_valid
  # end

  it "should have timestamps" do
    @asset.should respond_to(:created_at)
    @asset.should respond_to(:updated_at)
  end

  context "with uploaded files" do
    it "should allow us to attach one file"
  end
end
