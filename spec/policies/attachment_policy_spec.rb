require 'rails_helper'

describe AttachmentPolicy do
  subject { AttachmentPolicy }
  let(:user) {create(:user)}

  permissions ".scope" do
    it "only allows attachments from membership projects" do
      5.times {
        proj = create(:project)
        3.times {
          create(:member, project: proj, user: create(:user))
        }
        3.times {
          ticket = create(:ticket, project: proj)
          comment = create(:comment, ticket: ticket)
          3.times {
            create(:attachment, comment: comment)
          }
        }
      }
      Project.all.sample(3).each do |proj|
        create(:member, project: proj, user: user)
      end
      expect(AttachmentPolicy::Scope.new(user, Attachment).resolve).to have(27).entries
    end
  end

  permissions :create? do
    (Member::ROLES - ["regular", "restricted"]).each do |role|
      it "permits #{role}" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, commenter: user, ticket: ticket)
        attachment = create(:attachment, comment: comment)
        expect(subject).to permit(user, attachment)
      end
    end

    ["regular"].each do |role|
      it "permits #{role} if commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, commenter: user, ticket: ticket)
        attachment = create(:attachment, comment: comment)
        expect(subject).to permit(user, attachment)
      end

      it "denies #{role} if not commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, commenter: create(:user), ticket: ticket)
        attachment = create(:attachment, comment: comment)
        expect(subject).not_to permit(user, attachment)
      end
    end

    ["restricted"].each do |role|
      it "prevents #{role}" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        attachment = create(:attachment, comment: comment)
        expect(subject).not_to permit(user, attachment)
      end
    end

    it "prevents non-member" do
      membership = create(:member, user: user)
      ticket = create(:ticket, project: membership.project)
      comment = create(:comment, ticket: ticket)
      attachment = create(:attachment, comment: comment)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, attachment)
    end
  end

  permissions :show? do
    Member::ROLES.each do |role|
      it "permits #{role}" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        attachment = create(:attachment, comment: comment)
        expect(subject).to permit(user, attachment)
      end
    end

    it "prevents non-member" do
      membership = create(:member, user: user)
      ticket = create(:ticket, project: membership.project)
      comment = create(:comment, ticket: ticket)
      attachment = create(:attachment, comment: comment)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, attachment)
    end
  end

  permissions :destroy? do
    (Member::ROLES - ["restricted", "regular"]).each do |role|
      it "permits #{role} if commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket, commenter: user)
        attachment = create(:attachment, comment: comment)
        expect(subject).to permit(user, attachment)
      end

      it "permits #{role} if not commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        attachment = create(:attachment, comment: comment)
        expect(subject).to permit(user, attachment)
      end
    end

    ["regular"].each do |role|
      it "permits #{role} if commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket, commenter: user)
        attachment = create(:attachment, comment: comment)
        expect(subject).to permit(user, attachment)
      end

      it "prevents #{role} if not commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        attachment = create(:attachment, comment: comment)
        expect(subject).not_to permit(user, attachment)
      end
    end


    ["restricted"].each do |role|
      it "prevents #{role} if commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket, commenter: user)
        attachment = create(:attachment, comment: comment)
        expect(subject).to_not permit(user, attachment)
      end

      it "prevents #{role} if not commenter" do
        membership = create(role.to_sym, user: user)
        ticket = create(:ticket, project: membership.project)
        comment = create(:comment, ticket: ticket)
        attachment = create(:attachment, comment: comment)
        expect(subject).not_to permit(user, attachment)
      end
    end

    it "prevents non-member" do
      membership = create(:member, user: user)
      ticket = create(:ticket, project: membership.project)
      comment = create(:comment, ticket: ticket, commenter: user)
      attachment = create(:attachment, comment: comment)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, attachment)
    end
  end

end
