require 'rails_helper'

describe ProjectPolicy do
  subject { ProjectPolicy }
  let(:user) {create(:user)}

  permissions ".scope" do
    it "only allows projects from memberships" do
      5.times {
        #create a few projects
        proj = create(:project)
        #make sure they all have members
        3.times {
          create(:member, project: proj, user: create(:user))
        }
      }
      #assign user to a few of the projects
      Project.all.sample(3).each do |proj|
        create(:member, project: proj, user: user)
      end
      expect(ProjectPolicy::Scope.new(user, Project).resolve).to have(3).entries
    end    
  end

  permissions :create? do
    it "permits any user" do
      expect(subject).to permit(user, Project)
    end
  end

  permissions :show? do
    it "permits any member" do
      membership = create(:membership, user: user)
      expect(subject).to permit(user, membership.project)
    end

    it "prevents any non-member" do
      membership = create(:membership, user: user)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, membership.project)
    end
  end

  permissions :update? do
    ["owner", "administrator"].each do |role|
      it "permits #{role}" do
        membership = create(role.to_sym, user: user)
        expect(subject).to permit(user, membership.project)
      end
    end

    (Member::ROLES - ["owner", "administrator"]).each do |role|
      it "prevents #{role}" do
        membership = create(role.to_sym, user: user)
        expect(subject).not_to permit(user, membership.project)
      end
    end

    it "prevents non-members" do
      ownership = create(:owner, user: user)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, ownership.project)
    end
  end

  permissions :delete? do
    it "permits owner" do
      ownership = create(:owner, user: user)
      expect(subject).to permit(user, ownership.project)
    end

    (Member::ROLES - ["owner"]).each do |role|
      it "prevents #{role}" do
        membership = create(role.to_sym, user: user)
        expect(subject).not_to permit(user, membership.project)
      end
    end

  end
end
