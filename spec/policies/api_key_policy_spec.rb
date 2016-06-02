require 'rails_helper'

describe ApiKeyPolicy do
  subject { ApiKeyPolicy }
  let(:user) {create(:user)}

  permissions ".scope" do
    it "only allows api keys from membership projects" do
      5.times {
        proj = create(:project)
        3.times {
          create(:member, project: proj, user: create(:user))
        }
        3.times {
          create(:api_key, project: proj)
        }
      }
      #assign user to a few of the projects
      Project.all.sample(3).each do |proj|
        create(:member, project: proj, user: user)
      end
      expect(ApiKeyPolicy::Scope.new(user, ApiKey).resolve).to have(9).entries
    end
  end

  permissions :create? do
    (Member::ROLES - ["restricted"]).each do |role|
      it "permits #{role}" do
        membership = create(role.to_sym, user: user)
        api_key = create(:api_key, project: membership.project)
        expect(subject).to permit(user, api_key)
      end
    end

    ["restricted"].each do |role|
      it "prevents #{role}" do
        membership = create(role.to_sym, user: user)
        api_key = create(:api_key, project: membership.project)
        expect(subject).not_to permit(user, api_key)
      end
    end

    it "prevents non-member" do
      membership = create(:member, user: user)
      api_key = create(:api_key, project: membership.project)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, api_key)
    end
  end

  permissions :show? do
    Member::ROLES.each do |role|
      it "permits #{role}" do
        membership = create(role.to_sym, user: user)
        api_key = create(:api_key, project: membership.project)
        expect(subject).to permit(user, api_key)
      end
    end

    it "prevents non-member" do
      membership = create(:member, user: user)
      api_key = create(:api_key, project: membership.project)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, api_key)
    end
  end

  permissions :destroy? do
    (Member::ROLES - ["restricted", "regular"]).each do |role|
      it "permits #{role}" do
        membership = create(role.to_sym, user: user)
        api_key = create(:api_key, project: membership.project)
        expect(subject).to permit(user, api_key)
      end
    end

    ["restricted", "regular"].each do |role|
      it "prevents #{role}" do
        membership = create(role.to_sym, user: user)
        api_key = create(:ticket, project: membership.project)
        expect(subject).not_to permit(user, api_key)
      end
    end

    it "prevents non-member" do
      membership = create(:member, user: user)
      api_key = create(:ticket, project: membership.project)
      other_user = create(:user)
      expect(subject).not_to permit(other_user, api_key)
    end
  end

end
