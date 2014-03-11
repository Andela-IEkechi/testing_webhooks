require 'spec_helper'

describe Account do
  before(:each) do
    @account = create(:account)
  end

  it "should create a free plan if no params provided" do
    @account.plan.should eq "free"
  end

  it "should be enabled by default" do
    @account.enabled.should be_true
  end

  context "when specifying a plan" do
    it "must return the free plan" do
      account = create(:account, plan: "free")
      account.plan.should eq "free"
    end

    it "must return the startup plan" do
      account = create(:account, plan: "startups")
      account.plan.should eq "startups"
    end

    it "must return the company plan" do
      account = create(:account, plan: "small company")
      account.plan.should eq "small company"
    end

    it "must return the organization plan" do
      account = create(:account, plan: "large organization")
      account.plan.should eq "large organization"
    end
  end

  context "when changing plans" do
    it "should respond to :upgrade" do
      @account.should respond_to :upgrade
    end

    it "should respond to :downgrade" do
      @account.should respond_to :downgrade
    end

    it "should be able to upgrade" do
      if !(@account.plan == 'large')
        expect {
          @account.upgrade
        }.to change(@account, :plan)
      end
    end

    it "should be able to downgrade" do
      if !(@account.plan == 'free')
        expect {
          @account.downgrade
        }.to change(@account, :plan)
      end
    end
  end

  context "checking resources" do
    before(:each) do
      @usr = create(:user)
      @usr.account.upgrade
      @usr.account.save
      @usr.account.reload
      @sml_acc = @usr.account
    end
    it "should check if members available" do
      project = create(:project, :user => @usr)
      @sml_acc.available_members?.should eq(true)

      (@sml_acc.current_plan[:members] - 1).times do
        create(:membership, :project => project)
      end
      project.memberships.count.should be(@usr.account.current_plan[:members])
      @sml_acc.available_members?.should eq(false)
    end

    it "should check if projects available" do
      @sml_acc.available_projects?.should eq(true)
      @sml_acc.current_plan[:projects].times do
        create(:project, :user => @usr)
      end
      @sml_acc.available_projects?.should eq(false)
    end

    it "should check if storage available" do
      @sml_acc.available_storage?.should eq(true)

      project = create(:project, :user => @usr)
      mem = create(:membership, :user_id => @usr.id, :project_id => project.id, :role => 'admin')
      ticket = create(:ticket)
      comment = create(:comment)

      project.tickets<<ticket
      ticket.comments<<comment

      100.times do
        asset = create(:comment_asset)
        comment.assets<<asset
        asset.save
        asset.update_column(:filesize, (2*1025**3)/100 )
      end

      @sml_acc.available_storage?.should eq(false)
    end
  end
end