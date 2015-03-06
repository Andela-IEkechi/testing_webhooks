require 'spec_helper'

describe Project do
  let(:subject) {create(:project)}

  it {expect(subject).to belong_to(:user)}
  it {expect(subject).to validate_presence_of(:user)}
  it {expect(subject).to have_many(:features)}
  it {expect(subject).to have_many(:tickets)}
  it {expect(subject).to have_many(:sprints)}
  it {expect(subject).to have_many(:assets)}
  it {expect(subject).to have_many(:ticket_statuses)}
  it {expect(subject).to have_many(:memberships)}
  it {expect(subject).to have_many(:api_keys)}
  it {expect(subject).to respond_to(:logo)}
  it {expect(subject).to respond_to(:title)}
  it {expect(subject).to validate_presence_of(:title)}
  it {expect(subject).to respond_to(:private)}
  it {expect(subject).to respond_to(:description)}

  it "should have a working factory" do
    expect(subject).to_not be_nil
  end

  it "should make a private project by default" do
    expect(subject).to be_private
  end

  it "should have a working factory that adds tickets" do
    project_with_tickets = create(:project_with_tickets)
    expect(project_with_tickets).to_not be_nil
    expect(project_with_tickets.tickets.count).to eq(1)
  end

  it "gives it's title on .to_s" do
    subject.title = "A testing project"
    expect(subject.to_s).to eq(subject.title)
  end

  it "optionally has a description" do
    subject.description = nil
    expect(subject).to be_valid
    subject.description = Faker::Lorem.sentence
    expect(subject).to be_valid
  end

  it "should create default statuses of new and closed" do
    expect(subject.ticket_statuses.collect(&:name).sort).to eq(['new', 'closed'])
  end

  it "should have an owner membership" do
    expect(subject.memberships.collect(&:user_id).include?(subject.user_id)).to eq(true)
  end

  it "should allow duplicate titles for the same user" do
    #we need this to be true, because a user may inherit a project with the same title as one they already own
    joe = create(:user)
    project_one = create(:project, :user => joe)
    expect(project_one).to be_valid
    #now create the duplicate name
    duplicate = build(:project, :user => joe, :title => project_one.title)
    expect(duplicate).to be_valid
  end

  it "should allow duplicate titles for different users" do
    joe = create(:user)
    sue = create(:user)
    project_one = create(:project, :user => joe)
    expect(project_one).to be_valid
    #now create the duplicate name but for the other user
    duplicate = build(:project, :user => sue, :title => project_one.title)
    expect(duplicate).to be_valid
  end

  it "should delete related features when it's destroyed" do
    expect {
      create(:feature, :project => subject)
      create(:feature, :project => subject)
    }.to change(Feature, :count).by(2)
    expect {
      subject.destroy
    }.to change(Feature,:count).by(-2)
  end

  it "should delete related tickets when it's destroyed" do
    expect {
      create(:ticket, :project => subject)
      create(:ticket, :project => subject)
    }.to change(Ticket, :count).by(2)
    expect {
      subject.destroy
    }.to change(Ticket,:count).by(-2)
  end

  it "should delete related sprints when it's destroyed" do
    expect {
      create(:sprint, :project => subject)
      create(:sprint, :project => subject)
    }.to change(Sprint, :count).by(2)
    expect {
      subject.destroy
    }.to change(Sprint,:count).by(-2)
  end

  it "should delete related ticket_statuses when it's destroyed" do
    expect(subject).to have_at_least(2).ticket_statuses
    expect {
      subject.destroy
    }.to change(TicketStatus,:count).by(-2) #two default statuses
  end

  it "should not be deleted when a related ticket_statuses is destroyed" do
    expect(subject.ticket_statuses.count).to eq(2)
    expect {
      subject.ticket_statuses.first.destroy
    }.to change(Project,:count).by(0)
  end

  it "should have optional API keys to allow external parties to interface with it" do
    expect(subject.api_keys.count).to eq(0)
    expect {
      subject.api_keys << create(:api_key, :project => subject, :name => "key one")
      subject.api_keys << create(:api_key, :project => subject, :name => "key two")
    }.to change{subject.api_keys.count}.from(0).to(2)
  end

  it "should be a private project by default" do
    expect(Project.new().private?).to eq(true)
  end

  it "should be able to be a public project" do
    subject.private = false
    expect(subject.public?).to eq(true)
  end

  it "should not have an API key by default" do
    expect(subject.api_keys.count).to eq(0)
  end

  it "should be sorted alphabetically by default" do
    #create a few projects
    5.times do
      create(:project, :title => [*('A'..'Z')].sample(6).join)
    end
    expect(Project.all.collect(&:title)).to eq(Project.all.collect(&:title).sort)
  end

  it "should be sorted alphabetically for a user" do
    #create a few projects for a single user
    5.times do
      create(:project, :title => [*('A'..'Z')].sample(6).join, :user => subject.user)
    end
    subject.user.projects.count.to eq(6)
    subject.user.projects.all.collect(&:title) == subject.user.projects.all.collect(&:title).sort
  end

  context "with memberships" do
    it "should have the project owner in a membership" do
      subject.memberships.to have(1).membership
      subject.memberships.first.user_id.to eq(subject.user.id)
    end

    it "should allow multiple memberships" do
      expect {
        subject.memberships << create(:membership)
        subject.memberships << create(:membership)
      }.to change{subject.memberships}.by(2)
    end

    it "should sort memberships by email ASC" do
      4.times do
        subject.memberships << create(:membership)
      end
      membership_emails = subject.memberships.all.collect{|m| m.user.email}
      ordered_emails = subject.memberships.all.sort{|a,b| a.user.email <=> b.user.email}.collect{ |m| m.user.email}
      expect(membership_emails).to eq(ordered_emails)
    end
  end

  context "with tickets" do
    before(:each) do
      10.times do
        title = [*('A'..'Z')].sample(8).join
        subject.tickets.create(:title => title)
      end
    end

    it "should return tickets ordered by id" do
      ids = subject.tickets.collect(&:id)
      ids.to eq(ids.sort)
    end

    it "should not return tickets by creation date" do
      first = subject.tickets.first
      first.created_at = Time.now
      first.save

      ids = subject.tickets.collect(&:id)
      ids.to eq(ids.sort)
    end
  end
end
