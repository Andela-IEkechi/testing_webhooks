require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:subject) {create(:board)}

  it "enables paper trail" do
    is_expected.to be_versioned
  end

  it {is_expected.to belong_to :project}
  it {is_expected.to have_many :statuses}
  it {is_expected.to have_many :comments}
  it {is_expected.to have_many(:tickets)}
  it {is_expected.to have_many(:documents)}

  it {is_expected.to validate_uniqueness_of(:name).scoped_to(:project_id)}
  it {is_expected.to validate_length_of(:name).is_at_least(3)}

  #tickets returns a distinct list of tickets
  it ".tickets contains no duplicates" do
    #create a ticket on the board
    ticket = create(:ticket, project: subject.project)
    #create a bunch of comments on the ticket, each pointint got the board
    5.times do
      create(:comment, ticket: ticket, board: subject)
    end
    assert (subject.comments.count == 5), "expected 5 comments"
    expect(subject.tickets).to have_exactly(1).match
  end
end
