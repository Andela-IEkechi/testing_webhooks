require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  context 'anyone' do
    it 'should be able to manage their own profile'
    it 'should not be able to a profile which is not theirs'

    it 'should be able to manage their own account'
    it 'should not be able to an account which is not theirs'

    it 'should be able to create a new project'
  end

  #when a user is an admin member of a project
  context 'admins' do
    it 'should be able to manage the project'
    it 'should be able to manage features'
    it 'should be able to manage sprints'
    it 'should be able to view all tickets'
    it 'should be able to view all comments in a ticket'
    it 'should be able to manage their own tickets'
    it 'should be able to manage their own comments'
  end

  #when a user is a regular member of a project
  context 'regular' do
    it 'should not be able to manage the project'
    it 'should not be able to manage features'
    it 'should not be able to manage sprints'
    it 'should be able to view all features'
    it 'should be able to view all sprints'
    it 'should be able to view all tickets'
    it 'should be able to view all comments in a ticket'
    it 'should be able to manage their own tickets'
    it 'should be able to manage their own comments'
  end

  #when a user is a restricted member of a project
  context 'regular' do
    it 'should not be able to manage the project'
    it 'should not be able to manage features'
    it 'should not be able to manage sprints'
    it 'should be able to view all features'
    it 'should be able to view all sprints'
    it 'should be able to view all tickets'
    it 'should be able to view all comments in a ticket'
    it 'should not be able to manage their own tickets'
    it 'should not be able to manage their own comments'
  end

  #when a user does not belong to a project...
  context 'non-members' do
    it 'should not be able to view/manage projects'
    it 'should not be able to view/manage features'
    it 'should not be able to view/manage sprints'
    it 'should not be able to view/manage tickets'
    it 'should not be able to view/manage comments'
  end
end