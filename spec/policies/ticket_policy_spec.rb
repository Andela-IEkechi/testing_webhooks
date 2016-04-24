require 'rails_helper'

describe TicketPolicy do
  subject { TicketPolicy }
  let(:user) {create(:user)}

  permissions ".scope" do
    it "only allows tickets from membership projects" do
      5.times {
        #create a few projects
        proj = create(:project)
        #make sure they all have members
        3.times {
          create(:member, project: proj, user: create(:user))
        }
        #create some tickets in each
        3.times {
          create(:ticket, project: proj)
        }
      }
      #assign user to a few of the projects
      Project.all.sample(3).each do |proj|
        create(:member, project: proj, user: user)
      end
      # we dont realy every call tickets without a project, but the scope will at least indicate a limit
      expect(TicketPolicy::Scope.new(user, Ticket).resolve).to have(9).entries
    end    
  end

  permissions :create? do
    (Member::ROLES - ["restricted"]).each do |role|
      it "permits #{role}" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        expect(subject).to permit(user, ticket)
      end
    end

    ["restricted"].each do |role|
      it "prevents #{role}" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        expect(subject).not_to permit(user, ticket)
      end
    end

    it "prevents non-member" do
      membership = create(:member, user: user)
      ticket = create(:ticket, project: membership.project)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, ticket)
    end
  end

  # permissions :show? do
  #   it "permits any member" do
  #     membership = create(:membership, user: user)
  #     expect(subject).to permit(user, membership.project)
  #   end

  #   it "prevents any non-member" do
  #     membership = create(:membership, user: user)
  #     other_user = create(:user)
  #     expect(subject).not_to permit(other_user, membership.project)
  #   end
  # end

  # permissions :update? do
  #   ["owner", "administrator"].each do |role|
  #     it "permits #{role}" do
  #       membership = create(role.to_sym, user: user)
  #       expect(subject).to permit(user, membership.project)
  #     end
  #   end

  #   (Member::ROLES - ["owner", "administrator"]).each do |role|
  #     it "prevents #{role}" do
  #       membership = create(role.to_sym, user: user)
  #       expect(subject).not_to permit(user, membership.project)
  #     end
  #   end

  #   it "prevents non-members" do
  #     ownership = create(:owner, user: user)
  #     other_user = create(:user)
  #     expect(subject).not_to permit(other_user, ownership.project)
  #   end
  # end

  # permissions :delete? do
  #   it "permits owner" do
  #     ownership = create(:owner, user: user)
  #     expect(subject).to permit(user, ownership.project)
  #   end

  #   (Member::ROLES - ["owner"]).each do |role|
  #     it "prevents #{role}" do
  #       membership = create(role.to_sym, user: user)
  #       expect(subject).not_to permit(user, membership.project)
  #     end
  #   end
  # end
end
