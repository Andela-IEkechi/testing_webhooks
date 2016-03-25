require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:subject){create(:project)}

  it "enables paper trail" do
    is_expected.to be_versioned
  end

  it {is_expected.to have_many(:statuses).dependent(:destroy)}
  it {is_expected.to have_many(:members).dependent(:destroy)}
  it {is_expected.to have_many(:boards).dependent(:destroy)}
  it {is_expected.to have_many(:tickets).dependent(:destroy)}
  it {is_expected.to have_many(:documents).dependent(:destroy)}

  it {is_expected.to validate_length_of(:name).is_at_least(3)}

  it {is_expected.to accept_nested_attributes_for(:statuses).allow_destroy(true)}
  it {is_expected.to accept_nested_attributes_for(:members).allow_destroy(true)}
  it {is_expected.to accept_nested_attributes_for(:documents).allow_destroy(true)}

  describe ".ensure_system_statuses" do
    it "creates default statuses on the project" do
      expect {
        subject.touch
      }
      expect(subject.statuses).to have_exactly(Status::SYSTEM.values.flatten.count).matches
    end

    it "is called :after_create" do
      subject = build(:project)
      expect(subject).to receive(:ensure_system_statuses)
      subject.save
    end
  end

  describe ".has_member?" do
    it "false unless the param is a User" do
      expect(subject.has_member?(Hash.new)).to eq(false)
    end

    it "false if the user is not in the project" do
      expect(subject.has_member?(create(:user))).to eq(false)
    end

    it "true if the user is in the project" do
      subject.members << create(:member, project: subject)
      expect(subject.has_member?(subject.members.sample.user)).to eq(true)
    end
  end
end
