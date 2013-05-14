require 'spec_helper'

describe Membership do
  before(:each) do
    @membership = create(:membership)
  end

  it 'should have a user' do
    @membership.user.should_not be_nil
  end

  it 'should have a project' do
    @membership.project.should_not be_nil
  end

  it 'should find a user by their email' do
    #create a new membership in the same project
    memberships = @membership.project.memberships.by_email(@membership.user.email)
    memberships.should have(1).entry
    memberships[0].user.email.should eq(@membership.user.email)
  end

end
