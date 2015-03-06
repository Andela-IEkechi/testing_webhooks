require 'spec_helper'
require 'shared/examples_for_scoped'

describe Feature do
  let(:subject) {create(:feature)}

  it{expect(subject).to belong_to(:project)}
  it{expect(subject).to validate_presence_of(:project)}
  it{expect(subject).to have_many(:assets)}
  it{expect(subject).to validate_presence_of(:title)}
  it{expect(subject).to validate_uniqueness_of(:title).scoped_to(:project_id)}

  it_behaves_like 'scoped' do
    let(:scoped_class) { Feature }
  end

  it "must have a working factory" do
    expect(subject).to_not be_nil
  end

  it "should have a valid factory" do
    expect(subject).to be_valid
  end

  it "must have a title" do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it "gives it's title on to_s" do
    expect(subject.to_s).to eq(subject.title)
  end

  it "has an optional due date" do
    subject.due_on = nil
    expect(subject).to be_valid
    subject.due_on = Date.today + 5.days
    expect(subject).to be_valid
  end

  it "has an optional description" do
    subject.description = nil
    expect(subject).to be_valid

    subject.description = 'a nice description'
    expect(subject).to be_valid
  end

  it "must have unique title in the project" do
    dup_feature = build(:feature, :title => subject.title, :project => subject.project)
    expect(dup_feature).to_not be_valid
  end

  it "can have a duplicate title across projects" do
    other_project = create(:project)
    dup_feature = create(:feature, :title => subject.title, :project => other_project)
    expect(subject.title).to eq(dup_feature.title)
    expect(dup_feature).to be_valid
  end

  it "must have a valid project" do
    subject.project = nil
    expect(subject).to_not be_valid
  end

  it "should return the scoped_id when an id is implied" do
    subject.scoped_id = subject.project.features_sequence + 1
    expect(subject.id).to_not eq(subject.scoped_id)
    expect(subject.to_param).to eq(subject.scoped_id)
  end

  it "orders by :title ASC" do
    create(:feature, :title => "zzzz this should be last")
    5.times {
      create(:feature)
    }
    expect(Feature.all.collect(&:title)).to eq(Feature.all.collect(&:title).sort)
  end

  context "without tickets" do
    it "should have a 0 cost if there are no tickets" do
      expect(subject).to have(0).assigned_tickets
      expect(subject.cost).to eq(0)
    end
  end

  context "with tickets" do
    before(:each) do
      create(:ticket, :project => subject.project)
      create(:ticket, :project => subject.project)
    end

    it "should report on the assigned tickets" do
      subject.project.tickets.each do |ticket|
        create(:comment, :feature => subject)
      end
      subject.reload
      expect(subject.assigned_tickets.count).to eq(subject.project.tickets.count)
    end

    it "must be able to contain tickets" do
      expect(subject).to respond_to(:assigned_tickets)
    end

    it "must sum the costs of all the tickets in it" do
      subject.assigned_tickets.each do |ticket|
        ticket.comments.create(:feature => subject, :cost => 2)
      end
      expect(subject.cost).to eq(subject.assigned_tickets.count * 2)
    end

    it "should not report the same ticket as assigned multiple times" do
      expect(subject.assigned_tickets.count).to eq(0)
      commentor = create(:user)
      bad_ticket = create(:ticket, :project => subject.project)

      create(:comment, :ticket => bad_ticket, :feature => subject)
      expect(bad_ticket).to be_valid
      subject.reload
      expect(subject.assigned_tickets.count).to eq(1)

      create(:comment, :ticket => bad_ticket, :feature => subject)
      expect(bad_ticket).to be_valid
      subject.reload
      expect(subject.assigned_tickets.count).to eq(1)
    end
  end

end
