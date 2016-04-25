require 'rails_helper'

describe CommentPolicy do
  subject { CommentPolicy }
  let(:user) {create(:user)}

  permissions ".scope" do
    it "only allows comments from membership projects" do
      5.times {
        #create a few projects
        proj = create(:project)
        #make sure they all have members
        3.times {
          create(:member, project: proj, user: create(:user))
        }
        #create some tickets in each
        3.times {
          ticket = create(:ticket, project: proj)
          #create some comments in each ticket
          3.times {
            create(:comment, ticket: ticket)
          }
        }
      }
      #assign user to a few of the projects
      Project.all.sample(3).each do |proj|
        create(:member, project: proj, user: user)
      end
      # we dont realy every call tickets without a project, but the scope will at least indicate a limit
      expect(CommentPolicy::Scope.new(user, Comment).resolve).to have(27).entries
    end    
  end

  permissions :create? do
    (Member::ROLES - ["restricted"]).each do |role|
      it "permits #{role}" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        expect(subject).to permit(user, comment)
      end
    end

    ["restricted"].each do |role|
      it "prevents #{role}" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        expect(subject).not_to permit(user, comment)
      end
    end

    it "prevents non-member" do
      membership = create(:member, user: user)
      ticket = create(:ticket, project: membership.project)
      comment = create(:comment, ticket: ticket)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, comment)
    end
  end

  permissions :show? do
    Member::ROLES.each do |role|
      it "permits #{role}" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        expect(subject).to permit(user, comment)
      end
    end

    it "prevents non-member" do
      membership = create(:member, user: user)
      ticket = create(:ticket, project: membership.project)
      comment = create(:comment, ticket: ticket)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, comment)
    end
  end

  permissions :update? do
    (Member::ROLES - ["restricted"]).each do |role|
      it "permits #{role} when commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket, commenter: user)
        expect(subject).to permit(user, comment)
      end

      it "prevents #{role} when not commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        expect(subject).not_to permit(user, comment)
      end
    end

    ["restricted"].each do |role|
      it "prevents #{role} if commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket, commenter: user)
        expect(subject).not_to permit(user, comment)
      end

      it "prevents #{role} if not commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        expect(subject).not_to permit(user, ticket)
      end
    end

    it "prevents non-member if not commenter" do
      membership = create(:member, user: user)
      ticket = create(:ticket, project: membership.project)
      comment = create(:comment, ticket: ticket)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, comment)
    end

    it "prevents non-member if commenter" do
      membership = create(:member, user: user)
      ticket = create(:ticket, project: membership.project)
      comment = create(:comment, ticket: ticket, commenter: user)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, comment)
    end
  end

  permissions :delete? do
    (Member::ROLES - ["restricted", "regular"]).each do |role|
      it "permits #{role} if commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket, commenter: user)
        expect(subject).to permit(user, comment)
      end

      it "permits #{role} if not commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        expect(subject).to permit(user, comment)
      end
    end

    ["regular"].each do |role|
      it "permits #{role} if commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket, commenter: user)
        expect(subject).to permit(user, comment)
      end

      it "prevents #{role} if not commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        expect(subject).not_to permit(user, comment)
      end
    end


    ["restricted"].each do |role|
      it "prevents #{role} if commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket, commenter: user)
        expect(subject).to permit(user, comment)
      end

      it "prevents #{role} if not commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        expect(subject).not_to permit(user, comment)
      end
    end

    it "prevents non-member" do
      membership = create(:member, user: user)
      ticket = create(:ticket, project: membership.project)
      comment = create(:comment, ticket: ticket, commenter: user)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, comment)
    end
  end

end
