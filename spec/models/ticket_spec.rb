require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:subject){create(:ticket)}

  it "enables paper trail" do
    is_expected.to be_versioned
  end

  it {is_expected.to belong_to :project}
  it {is_expected.to belong_to :comment} #split from this comment
  it {is_expected.to have_many :comments}
  it {is_expected.to have_many :assets}
  it {is_expected.to have_many :tickets} #tickets split from our comments

  it {is_expected.to validate_presence_of(:project).with_message("must exist")}
  it {is_expected.to validate_length_of(:title).is_at_least(3)}

  describe "scopes" do
    describe "#ordered" do
      it "returns ticket in ascending order" do
        5.times do
          create(:ticket, order: rand(100))
        end
        expect(Ticket.ordered.pluck(:order)).to eq(Ticket.pluck(:order).sort)
      end
    end

    describe "#for_status" do
      it "returns only tickets that belong to the given status" do
        #create some tickets
        project = create(:project_with_tickets_and_comments)

        #get a status from one of the tickets
        status = project.tickets.sample.status

        tickets_count = project.tickets.select{|t| t.status.id == status.id}.count
        expect(project.tickets.for_status(status)).to have_exactly(tickets_count).matches
      end
    end

    describe "#for_cost" do
      it "returns only tickets that belong to the given cost" do
        #create some tickets
        project = create(:project_with_tickets_and_comments)

        #get a cost from one of the tickets
        cost = project.tickets.sample.cost

        tickets_count = project.tickets.select{|t| t.cost == cost}.count
        expect(project.tickets.for_cost(cost)).to have_exactly(tickets_count).matches
      end
    end

    describe "#for_assignee" do
      it "returns only tickets that belong to the given assignee" do
        #create some tickets
        project = create(:project_with_tickets_and_comments)

        #get a assignee from one of the tickets
        assignee = project.tickets.sample.assignee

        tickets_count = project.tickets.select{|t| t.assignee.id == assignee.id}.count
        expect(project.tickets.for_assignee(assignee)).to have_exactly(tickets_count).matches
      end
    end

    describe "#for_user" do
      it "returns only tickets that belong to the given user" do
        #create some tickets
        project = create(:project_with_tickets_and_comments)

        #get a user from one of the tickets
        user = project.tickets.sample.user

        tickets_count = project.tickets.select{|t| t.user.id == user.id}.count
        expect(project.tickets.for_user(user)).to have_exactly(tickets_count).matches
      end
    end

    describe "#for_board" do
      it "returns only tickets that belong to the given board" do
        #create some tickets
        project = create(:project_with_tickets_and_comments)

        #get a board from one of the tickets
        board = project.tickets.sample.board

        tickets_count = project.tickets.select{|t| t.board.id == board.id}.count
        expect(project.tickets.for_board(board)).to have_exactly(tickets_count).matches
      end
    end
  end

  describe "set_last_comment!" do
    it "updates all comments to be :last = false, except the last one" do
      ticket = create(:ticket_with_comments)
      ticket.comments.update_all(last: true)
      expect(ticket.comments.where(last: true)).to have_exactly(ticket.comments.count).matches
      ticket.set_last_comment!
      expect(ticket.comments.where(last: true)).to have_exactly(1).match
    end
  end

  describe "last_comment" do
    it "returns the last comment, by :id" do
      ticket = create(:ticket_with_comments)
      expect(ticket.last_comment).to eq(ticket.comments.order(id: :asc).last)
    end
  end

  describe "first_comment" do
    it "returns the first comment, by :id" do
      ticket = create(:ticket_with_comments)
      expect(ticket.first_comment).to eq(ticket.comments.order(id: :asc).first)
    end
  end

  it {is_expected.to delegate_method(:assignee).to(:last_comment)}
  it {is_expected.to delegate_method(:status).to(:last_comment)}
  it {is_expected.to delegate_method(:user).to(:first_comment)}
  it {is_expected.to delegate_method(:board).to(:last_comment)}
  it {is_expected.to delegate_method(:cost).to(:last_comment)}

  describe ".move!" do
    before(:each) do
      @status = subject.project.statuses.sample
      subject.project.members << create(:member, project: subject.project)
      @user = subject.project.members.sample.user
      subject.reload
    end

    context "returns nil" do
      it "unless status is from the ticket's project" do
        expect(subject.move!(create(:status), rand(10), @user)).to eq(nil)
      end

      it "unless user belongs to the ticket's project " do
        expect(subject.move!(@status, rand(10), create(:user))).to eq(nil)
      end
    end

    it "creates a new comment" do
      expect {
        subject.move!(@status, rand(10), @user)
      }.to change{subject.tickets.count}.by(1)
    end

    context "comment" do
      it "belongs to the given user" do
        subject.move!(@status, rand(10), @user)
        expect(subject.last_comment.user).to eq(@user)
      end

      it "belongs to the given status" do
        subject.move!(@status, rand(10), @user)
        expect(subject.last_comment.status).to eq(@status)
      end
    end

    it "calls :reorder! with the new order" do
      expect(subject).to receive(:reorder!)
      subject.move!(@status, rand(10), @user)
    end

    it "returns self" do
      expect(subject.move!(@status, rand(10), @user)).to eq(subject)
    end
  end
end
