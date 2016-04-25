require 'rails_helper'

describe CommentPolicy do
  subject { CommentPolicy }
  let(:user) {create(:user)}

  # permissions ".scope" do
  #   it "only allows tickets from membership projects" do
  #     5.times {
  #       #create a few projects
  #       proj = create(:project)
  #       #make sure they all have members
  #       3.times {
  #         create(:member, project: proj, user: create(:user))
  #       }
  #       #create some tickets in each
  #       3.times {
  #         create(:ticket, project: proj)
  #       }
  #     }
  #     #assign user to a few of the projects
  #     Project.all.sample(3).each do |proj|
  #       create(:member, project: proj, user: user)
  #     end
  #     # we dont realy every call tickets without a project, but the scope will at least indicate a limit
  #     expect(TicketPolicy::Scope.new(user, Ticket).resolve).to have(9).entries
  #   end    
  # end

  # permissions :create? do
  #   (Member::ROLES - ["restricted"]).each do |role|
  #     it "permits #{role}" do
  #       membership = create(role.to_sym, user: user)
  #       ticket = create(:ticket, project: membership.project)
  #       expect(subject).to permit(user, ticket)
  #     end
  #   end

  #   ["restricted"].each do |role|
  #     it "prevents #{role}" do
  #       membership = create(role.to_sym, user: user)
  #       ticket = create(:ticket, project: membership.project)
  #       expect(subject).not_to permit(user, ticket)
  #     end
  #   end

  #   it "prevents non-member" do
  #     membership = create(:member, user: user)
  #     ticket = create(:ticket, project: membership.project)
  #     other_user = create(:user)
  #     expect(subject).not_to permit(other_user, ticket)
  #   end
  # end

  # permissions :show? do
  #   Member::ROLES.each do |role|
  #     it "permits #{role}" do
  #       membership = create(role.to_sym, user: user)
  #       ticket = create(:ticket, project: membership.project)
  #       expect(subject).to permit(user, ticket)
  #     end
  #   end

  #   it "prevents non-member" do
  #     membership = create(:member, user: user)
  #     ticket = create(:ticket, project: membership.project)
  #     other_user = create(:user)
  #     expect(subject).not_to permit(other_user, ticket)
  #   end
  # end

  # permissions :update? do
  #   (Member::ROLES - ["restricted", "regular"]).each do |role|
  #     it "permits #{role}" do
  #       membership = create(role.to_sym, user: user)
  #       ticket = create(:ticket, project: membership.project)
  #       expect(subject).to permit(user, ticket)
  #     end
  #   end

  #   ["restricted", "regular"].each do |role|
  #     it "prevents #{role}" do
  #       membership = create(role.to_sym, user: user)
  #       ticket = create(:ticket, project: membership.project)
  #       expect(subject).not_to permit(user, ticket)
  #     end
  #   end

  #   it "prevents non-member" do
  #     membership = create(:member, user: user)
  #     ticket = create(:ticket, project: membership.project)
  #     other_user = create(:user)
  #     expect(subject).not_to permit(other_user, ticket)
  #   end

  #   it "permits regular member if they are the ticket creator" do
  #     membership = create(:regular, user: user)
  #     ticket = create(:ticket, project: membership.project)
  #     ticket.comments << create(:comment, commenter: user)
  #     expect(subject).to permit(user, ticket)
  #   end  

  #   it "permits regular member if they are the ticket assignee" do
  #     membership = create(:regular, user: user)
  #     ticket = create(:ticket, project: membership.project)
  #     ticket.comments << create(:comment, assignee: user)
  #     expect(subject).to permit(user, ticket)
  #   end    
  # end

  # permissions :delete? do
  #   (Member::ROLES - ["restricted", "regular"]).each do |role|
  #     it "permits #{role}" do
  #       membership = create(role.to_sym, user: user)
  #       ticket = create(:ticket, project: membership.project)
  #       expect(subject).to permit(user, ticket)
  #     end
  #   end

  #   ["restricted", "regular"].each do |role|
  #     it "prevents #{role}" do
  #       membership = create(role.to_sym, user: user)
  #       ticket = create(:ticket, project: membership.project)
  #       expect(subject).not_to permit(user, ticket)
  #     end
  #   end

  #   it "prevents non-member" do
  #     membership = create(:member, user: user)
  #     ticket = create(:ticket, project: membership.project)
  #     other_user = create(:user)
  #     expect(subject).not_to permit(other_user, ticket)
  #   end
  # end

end
