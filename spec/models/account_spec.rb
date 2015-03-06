require 'spec_helper'

describe Account do
  let(:subject) {create(:account)}

  it{expect(subject).to belong_to(:user)}
  it{expect(subject).to validate_presence_of(:user)}
  it{expect(subject).to validate_presence_of(:plan)}
  it{expect(subject).to respond_to(:current_plan)}
  it{expect(subject).to respond_to(:upgrade)}
  it{expect(subject).to respond_to(:downgrade)}
  it{expect(subject).to respond_to(:change_to)}
  it{expect(subject).to respond_to(:can_downgrade?)}

  it "should create a free plan of no params provided" do
    expect(subject.plan).to eq("free")
  end

  it "should be enbaled by default" do
    expect(subject.enabled).to eq(true)
  end

  context "when specifying a plan" do
    it "must return the free plan" do
      account = create(:account, plan: "free")
      expect(account.plan).to eq("free")
    end

    it "must return the startup plan" do
      account = create(:account, plan: "startup")
      expect(account.plan).to eq("startup")
    end

    it "must return the company plan" do
      account = create(:account, plan: "company")
      expect(account.plan).to eq("company")
    end

    it "must return the organization plan" do
      account = create(:account, plan: "organization")
      expect(account.plan).to eq("organization")
    end
  end

  context "when changing plans" do
    it "should respond to :upgrade" do
      expect(subject).to respond_to :upgrade
    end

    it "should respond to :downgrade" do
      expect(subject).to respond_to :downgrade
    end

    it "should be able to upgrade" do
      if !(subject.plan == 'large')
        expect {
          subject.upgrade
        }.to change(subject, :plan)
      end
    end

    it "should be able to downgrade" do
      if !(subject.plan == 'free')
        expect {
          subject.downgrade
        }.to change(subject, :plan)
      end
    end

  end
end
