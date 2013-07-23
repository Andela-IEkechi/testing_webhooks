# == Schema Information
#
# Table name: overviews
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  filter     :string(255)      default(""), not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Overview do
  context "factories" do
    it "has a valid factory" do
      overview = create(:overview)
      overview.should be_valid
    end
  end

  context "validation" do
    before(:each) do
      @overview = create(:overview)
    end
    it "should always belong to a user" do
      @overview.user = nil
      @overview.should_not be_valid
    end

    it "should always have a valid filter" do
      @overview.filter = nil
      @overview.should_not be_valid
    end

    it "must have a title" do
      @overview.title = nil
      @overview.should_not be_valid
      @overview.title = ''
      @overview.should_not be_valid
    end
  end

  context "with projects" do
    before(:each) do
      @overview = create(:overview)
    end
    it "should respond to #projects" do
      @overview.should respond_to(:projects)
    end

    it "should belong to 0 or more projects" do
      @overview.projects.clear
      @overview.should be_valid

      3.times do
        @overview.projects << create(:project, :user => @overview.user)
      end

      @overview.reload
      @overview.projects.should_not be_empty
      @overview.should be_valid
    end

    it "should respond to #any_project?" do
      @overview.should respond_to(:any_project?)
    end

    it "#any_project? should return true if there are no projects associated" do
      @overview.projects.should be_empty
      @overview.should be_any_project

      @overview.projects << create(:project, :user => @overview.user)
      @overview.reload
      @overview.should_not be_any_project
    end
  end


  context "has a title that" do
    before(:each) do
      @overview = create(:overview)
    end

    it "should be unique to the user" do
      dup_overview = build(:overview, :user => @overview.user, :title => @overview.title)
      dup_overview.should_not be_valid
    end

    it "can be duplicate between users" do
      alt_overview = build(:overview, :title => @overview.title)
      alt_overview.should be_valid
    end

    it "should not be too short" do
      @overview.title = 'ab' #2 is to short
      @overview.should_not be_valid
    end
    it "should not be too long" do
      @overview.title = 'abcdefghijk' #11 is too long
      @overview.should_not be_valid
    end
  end


end
