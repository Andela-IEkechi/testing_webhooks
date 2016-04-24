require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:subject) {create(:member)}

  it { should belong_to(:project) }  
  it { should belong_to(:user) }

  it { should respond_to(:role) }  
  it { should validate_inclusion_of(:role).in_array(Member::ROLES) }  

  describe "scopes" do
    before(:each) do
      #create a bunch of memberships
      Member::ROLES.each do |role|
        3.times {create(:member, role: role)}
      end
    end

    Member::ROLES.each do |role|
      it "##{role.pluralize}" do
        members = Member.send(role.pluralize.to_sym)
        roles = members.collect(&:role).select{|role| role == role.to_s}.uniq.compact
        expect(roles.count).to eq(1)
      end
    end

    it "#unrestricted" do
      members = Member.unrestricted
      roles = members.collect(&:role).select{|role| role == "restricted"}.uniq.compact
      expect(roles.count).to eq(0)
    end
  end
end
