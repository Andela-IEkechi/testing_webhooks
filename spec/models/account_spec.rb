require 'spec_helper'

describe Account, :focus do
  let(:subject) {create(:account)}

  it{expect(subject).to belong_to(:user)}
  it{expect(subject).to validate_presence_of(:user)}
  it{expect(subject).to validate_presence_of(:plan)}
  it{expect(subject).to respond_to(:current_plan)}
  it{expect(subject).to respond_to(:upgrade)}
  it{expect(subject).to respond_to(:downgrade)}
  it{expect(subject).to respond_to(:change_to)}
  it{expect(subject).to respond_to(:can_downgrade?)}

  it "creates a free plan of no params provided" do
    expect(subject.plan).to eq("free")
  end

  it "is enabled by default" do
    expect(subject.enabled).to eq(true)
  end

  context "when specifying a plan" do
    ["free", "small", "medium", "large"].each do |p|
      it "returns the #{p} plan" do
        account = create(:account, plan: p)
        expect(account.plan.to_s).to eq(p)
      end
    end
  end

  context "when changing plans" do
    it "should be able to upgrade" do
      subject.downgrade
      subject.save
      expect {
        subject.upgrade
      }.to change(subject, :plan)
    end

    it "should be able to downgrade" do
      subject.upgrade
      subject.save
      expect {
        subject.downgrade
      }.to change(subject, :plan)
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

    it "checks if memberships are available" do
      project = create(:project, :user => @usr)
      expect(@sml_acc.available_members?).to eq(true)

      (@sml_acc.current_plan[:members]).times do
        create(:membership, :project => project)
      end
      expect(@sml_acc.available_members?).to eq(false)
    end

    it "checks if projects are available" do
      @sml_acc.available_projects?.should eq(true)
      @sml_acc.current_plan[:projects].times do
        create(:project, :user => @usr)
      end
      expect(@sml_acc.available_projects?).to eq(false)
    end

    it "checks if storage is available" do
      @sml_acc.available_storage?.should eq(true)

      project = create(:project, :user => @usr)
      mem = create(:membership, :user_id => @usr.id, :project_id => project.id, :role => 'admin')
      ticket = create(:ticket)
      comment = create(:comment)

      project.tickets<<ticket
      ticket.comments<<comment

      #attach a few single large assets
      #we cant just attach one massive one, it overruns the DB integer field
      8.times do #must be a bianry power, or we get rounding problems
        asset = create(:asset, :project => project, :comment => comment)
        #use update column below to avoid callbacks which reset the size
        asset.update_column(:payload_size, @sml_acc.current_plan[:storage_gb]*(1024**3)/8)
      end
      expect(@sml_acc.available_storage?).to eq(false)
    end
  end

  describe ".block" do
    it "blocks the account" do
      subject.block!
      expect(subject.blocked).to eq(true)
    end
  end

  describe ".unblock!" do
    it "unblocks the account" do
      subject.unblock!
      expect(subject.blocked).to eq(false)
    end
  end
end
