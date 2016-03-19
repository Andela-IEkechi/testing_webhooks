require 'spec_helper'

describe Overview do
  let(:subject) {create(:overview)}

  it{expect(subject).to belong_to(:user)}
  it{expect(subject).to validate_presence_of(:user)}
  it{expect(subject).to have_and_belong_to_many(:projects)}
  it{expect(subject).to validate_uniqueness_of(:title).scoped_to(:user_id)}
  it{expect(subject).to validate_presence_of(:filter)}
  it{expect(subject).to respond_to(:any_project?)}
  it{expect(subject).to respond_to(:to_s)}

  context "factories" do
    it "has a valid factory" do
      overview = create(:overview)
      expect(overview).to be_valid
    end
  end

  context "validation" do
    #nothing to see here
  end

  context "with projects" do
    it "#any_project? should return true if there are no projects associated" do
      expect(subject.projects).to be_empty
      expect(subject).to be_any_project

      subject.projects << create(:project, :user => subject.user)
      subject.reload
      expect(subject).to_not be_any_project
    end
  end


  context "has a title that" do
    it "can be duplicate between users" do
      alt_overview = build(:overview, :title => subject.title)
      expect(alt_overview).to be_valid
    end

    it "should not be shorter than 3 characters" do
      subject.title = 'ab' #2 is to short
      expect(subject).to_not be_valid
    end

    it "should not be longer than 20 characters" do
      subject.title = 'abcdefghij abcdefghij' #21 is too long
      expect(subject).to_not be_valid
    end
  end


end
