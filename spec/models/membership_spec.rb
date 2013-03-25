require 'spec_helper'

describe Membership, :focus => true do
  before(:each) do
    @membership = create(:membership)
  end

  it 'should have a user' do
    @membership.user.should_not be_nil
  end

  it 'should have a project' do
    @membership.project.should_not be_nil
  end
  

end
