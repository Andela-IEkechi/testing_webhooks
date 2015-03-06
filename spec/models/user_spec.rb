require 'spec_helper'

describe User do
  let(:subject) {create(:user)}

  it {expect(subject).to have_one(:account)}
  it {expect(subject).to have_many(:projects)}
  it {expect(subject).to have_many(:tickets)}
  it {expect(subject).to have_many(:memberships)}
  it {expect(subject).to have_many(:overviews)}

  it {expect(subject).to respond_to(:soft_delete)}
  it {expect(subject).to respond_to(:active?)}
  it {expect(subject).to respond_to(:deleted?)}
  it {expect(subject).to respond_to(:active_for_authentication?)}
  it {expect(subject).to respond_to(:obfuscated)}

  shared_examples "a project member" do
    it "that can be a member in projects"
    it "that can see all the tickets for all the projects they are members of"
  end

  context "it has factories that" do
    it "should have a working factory" do
      user = create(:user)
      expect(user).to_not be_nil
    end

    it "should have a factory the uses a different email every time" do
      joe = create(:user)
      sue = create(:user)
      expect(joe.email).to_not eq(sue.email)
    end
  end

  context "when confirmed" do
    it_behaves_like "a project member"

    it "should be able to own many projects" do
      expect {
        create(:project, :user => subject)
        create(:project, :user => subject)
        subject.reload
      }.to change{subject.projects.count}.by(2)
    end

    it "should have access to all the tickets under all it's own projects" do
      project = create(:project_with_tickets, :user => subject)
      expect(project).to have_at_least(1).tickets
      subject.reload
      expect(subject).to have(project.tickets.count).tickets
    end

    it "should report it's email as to_s" do
      expect(subject.to_s).to eq(subject.email)
    end
  end

  context "when not confirmed" do
    before(:each) do
      @unconfirmed = create(:unconfirmed_user)
    end

    it_behaves_like "a project member"

    it "should be token authenticatable"

    it "should report it's email and (invite) as to_s" do
      expect(@unconfirmed.to_s).to match(@unconfirmed.email)
      expect(@unconfirmed.to_s).to match('invite')
    end
  end

  context "when terms not accepted" do
    it "should not allow user to be created" do
      user = build(:user_with_password)
      expect(user).to be_valid
      user.terms = "0"
      expect(user).to_not be_valid
    end
  end

  it "should have an account when it is created" do
    expect(subject.account).to_not be_nil
  end

  it "should have a free plan by default" do
    expect(subject.account.plan).to eq("free")
  end

  it "should be an active user by default" do
    expect(subject.active?).to eq(true)
  end

  it "should be able to obfuscate user information(email)" do
    expected = subject.email.gsub(/(.+@).+/,'\1...')
    expect(subject.obfuscated).to eq(expected)
  end

  it "should be possible to soft-delete users" do
    subject.soft_delete
    subject.reload
    expect(subject).to be_deleted
  end

  context 'has preferences' do
    it "should respond to 'preferences" do
      expect(subject).to respond_to :preferences
    end

    it "is an openstruct" do
      expect(subject.preferences.class).to eq(OpenStruct)
    end

    it "should preferences to be updated explicitly" do
      expect(subject.preferences.something).to eq(nil)
      subject.preferences.something = "example"
      expect(subject.preferences.something).to eq("example")
    end

    it "should preferences to be updated with a hash" do
      expect(subject.preferences.something).to eq(nil)
      subject.preferences = OpenStruct.new({'foo' => 'bar', 'bin' => 'baz'})
      expect(subject.preferences.foo).to eq("bar")
      expect(subject.preferences.bin).to eq("baz")
    end

  end

  context "when being deleted" do
    before(:each) do
    end

    it "should be prevented if they have open projects with other members " do
      project = create(:project, :user => subject)
      other_user = create(:user)
      membership_other = create(:membership, :user => other_user, :project => project, :role => "regular")
      subject.soft_delete
      subject.reload
      expect(subject).to_not be_deleted
    end

    it "should not be prevented if they have open projects with no other members " do
      subject.soft_delete
      subject.reload
      expect(subject).to be_deleted
    end

  end
end
