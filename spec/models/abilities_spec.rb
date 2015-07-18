require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  before(:each) do
    @user = create(:user)
    @ability = Ability.new(@user)
  end

  context 'any user' do
    it 'can manage their own profile' do
      @ability.should be_able_to(:manage, @user)
    end

    it 'cannot manage a profile which is not theirs' do
      other_user = create(:user)
      @ability.should_not be_able_to(:manage, other_user)
    end

    it 'can manage their own account' do
      account = create(:account, :user => @user)
      @ability.should be_able_to(:manage, account)
    end

    it 'cannot manage an account which is not theirs' do
      other_account = create(:account)
      @ability.should_not be_able_to(:manage, other_account)
    end

    it 'can create a new project' do
      @ability.should be_able_to(:create, Project)
    end
  end

  #when a user is an admin member of a project
  context 'admin members' do
    before (:each) do
      @project = create(:project, :user => @user)
      @membership = create(:membership, :user => @user, :project => @project, :role => 'admin')
    end

    it 'can manage the project' do
      @ability.should be_able_to(:manage, @project)
    end

    it 'can manage features' do
      feature = create(:feature, :project => @project)
      @ability.should be_able_to(:manage, feature)
    end

    it 'can manage sprints' do
      sprint = create(:sprint, :project => @project)
      @ability.should be_able_to(:manage, sprint)
    end

    it "can create memberships" do
      project = create(:project, :user => @user)
      @user.account.upgrade
      @ability.should be_able_to(:create, Membership)
    end

    it "cannot create membership if none available" do
      project = create(:project, :user_id => @user.id)
      @user.account.upgrade
      @user.account.current_plan[:members].times do
        create(:membership, :project_id => project.id, :user_id => @user.id)
      end
      @ability.should_not be_able_to(:create, Membership.new(:project_id => project.id))
    end

    it 'can view all tickets' do
      create(:ticket, :project => @project)
      @project.reload
      @ability.should be_able_to(:read, @project.tickets.first)
    end

    it 'can view all comments in a ticket' do
      ticket = create(:ticket, :project => @project)
      create(:comment, :ticket => ticket)
      ticket.reload
      @ability.should be_able_to(:read, ticket.comments.first)
    end

    it 'can manage their own tickets' do
      ticket = create(:ticket, :project => @project)
      #assign the ticket to a user with a comment
      create(:comment, :user => @user, :ticket => ticket)
      @ability.should be_able_to(:manage, ticket)
    end

    it 'can manage their own comments' do
      ticket = create(:ticket, :project => @project)
      comment = create(:comment, :ticket => ticket, :user => @user)
      @ability.should be_able_to(:read, comment)
    end
  end

  #when a user is a regular member of a project
  context 'regular members' do
    before (:each) do
      @project = create(:project)
      @membership = create(:membership, :user => @user, :project => @project, :role => 'regular')
    end

    it 'cannot manage the project' do
      @ability.should_not be_able_to(:manage, @project)
    end

    it 'cannot manage features' do
      feature = create(:feature, :project => @project)
      @ability.should_not be_able_to(:manage, feature)
    end

    it 'cannot manage sprints' do
      sprint = create(:sprint, :project => @project)
      @ability.should_not be_able_to(:manage, sprint)
    end

    it 'can view all features' do
      feature = create(:feature, :project => @project)
      @ability.should be_able_to(:read, feature)
    end

    it 'can view all sprints' do
      sprint = create(:sprint, :project => @project)
      @ability.should be_able_to(:read, sprint)
    end

    it 'can view all tickets' do
      ticket = create(:ticket, :project => @project)
      @ability.should be_able_to(:read, ticket)
    end

    it 'can view all comments in a ticket' do
      ticket = create(:ticket, :project => @project)
      comment = create(:comment, :ticket => ticket)
      @ability.should be_able_to(:read, comment)
    end

    it 'can manage their own tickets' do
      ticket = create(:ticket, :project => @project)
      comment = create(:comment, :ticket => ticket, :user => @user)
      @ability.should be_able_to(:manage, ticket)
    end

    it 'can manage their own comments' do
      ticket = create(:ticket, :project => @project)
      comment = create(:comment, :ticket => ticket, :user => @user)
      @ability.should be_able_to(:manage, comment)
    end

    it 'cannot manage a comment in a ticket which does not belong to them' do
      ticket = create(:ticket, :project => @project)
      comment = create(:comment, :ticket => ticket)
      @ability.should_not be_able_to(:manage, comment)
    end

  end

  #when a user is a restricted member of a project
  context 'restricted members' do
    before (:each) do
      @project = create(:project)
      @membership = create(:membership, :user => @user, :project => @project, :role => 'restricted')
    end

    it 'cannot manage the project' do
      @ability.should_not be_able_to(:manage, @project)
    end

    it 'cannot manage features' do
      feature = create(:feature, :project => @project)
      @ability.should_not be_able_to(:manage, feature)
    end

    it "cannot create a new feature" do
      @ability.should_not be_able_to(:create, @project.features.new())
    end

    it 'cannot manage sprints' do
      sprint = create(:sprint, :project => @project)
      @ability.should_not be_able_to(:manage, sprint)
    end

    it "cannot create a new sprint" do
      @ability.should_not be_able_to(:create, @project.sprints.new())
    end

    it 'can view all features' do
      feature = create(:feature, :project => @project)
      @ability.should be_able_to(:read, feature)
    end

    it 'can view all sprints' do
      sprint = create(:sprint, :project => @project)
      @ability.should be_able_to(:read, sprint)
    end

    it 'can view all tickets' do
      ticket = create(:ticket, :project => @project)
      @ability.should be_able_to(:read, ticket)
    end

    it 'can view all comments in a ticket' do
      ticket = create(:ticket, :project => @project)
      comment = create(:comment, :ticket => ticket)
      @ability.should be_able_to(:read, comment)
    end

    it 'cannot create their own tickets' do
      @ability.should_not be_able_to(:create, @project.tickets.new())
    end

    it 'cannot create their own comments' do
      ticket = create(:ticket, :project => @project)
      @ability.should_not be_able_to(:create, ticket.comments.new())
    end

    it 'cannot manage a comment in a ticket which does not belong to them' do
      ticket = create(:ticket, :project => @project)
      comment = create(:comment, :ticket => ticket)
      @ability.should_not be_able_to(:manage, comment)
    end

    it 'cannot manage a comment in a ticket which belongs to them' do
      ticket = create(:ticket, :project => @project)
      comment = create(:comment, :ticket => ticket, :user => @user)
      @ability.should_not be_able_to(:manage, comment)
    end

  end

  #when a user does not belong to a project...
  context 'non-members' do
    before (:each) do
      @project = create(:project)
    end

    it 'cannot view/manage projects' do
      @ability.should_not be_able_to(:read, @project)
      @ability.should_not be_able_to(:manage, @project)
    end

    it 'cannot view/manage features' do
      feature = create(:feature, :project => @project)
      @ability.should_not be_able_to(:read, feature)
      @ability.should_not be_able_to(:manage, feature)
    end

    it 'cannot view/manage sprints' do
      sprint = create(:sprint, :project => @project)
      @ability.should_not be_able_to(:read, sprint)
      @ability.should_not be_able_to(:manage, sprint)
    end

    it 'cannot view/manage tickets' do
      ticket = create(:ticket, :project => @project)
      @ability.should_not be_able_to(:read, ticket)
      @ability.should_not be_able_to(:manage, ticket)
    end

    it 'cannot view/manage comments' do
      ticket = create(:ticket, :project => @project)
      comment = create(:comment, :ticket => ticket)
      @ability.should_not be_able_to(:read, comment)
      @ability.should_not be_able_to(:manage, comment)
    end

  end
end
