require 'spec_helper'

describe GithubController do

  before :each do
    @project = create(:project)
    @user    = create(:user)
    @project.memberships.create(:user_id => @user.id)

    @ticket = create(:ticket, :project => @project)
    #we have to add a comment to the ticket, the factory does not because it sticks to
    #the model's rules, not the business logic
    @ticket.comments << create(:comment, :ticket => @ticket, :user => @user)

    @key = create(:api_key, :project => @project)
  	@payload = {
      after: "2d00bdaa3f0d41a3a9bc355eb38f6245e70d79a1",
      before: "4144b9ae4565cf74cbe6c1915123debbab1119bc",
      commits: [
        { added: [],
          author: {
            email: "#{@user.email}",
            name: "elarex",
            username: "elarex" },
          committer: {
            email: "#{@user.email}",
            name: "elarex",
            username: "elarex" },
          distinct: true,
          id: "bf73ba69c1f733fff5003527004b8806f899267d",
          message: "a commit message with one ticket: [##{@ticket.scoped_id}]",
          modified: [ "app/views/comments/_form_fields.html.erb" ],
          removed: [],
          timestamp: "2013-01-21T01:19:31-08:00",
          url: "https://github.com/Shuntyard/Conductor/commit/bf73ba69c1f733fff5003527004b8806f899267d"
        }
      ]
    }
  end

  it 'assigns a commit message to a ticket' do
    expect {
      post :commit, :token => @key.token, :payload => JSON.generate(@payload)
    }.to change{@ticket.comments.count}.from(1).to(2)
  end

  it 'assigns a commit message to a multiple tickets' do
    ticket2 = create(:ticket, :project => @project)
    ticket2.comments << create(:comment, :user => @user, :ticket => ticket2)

    @payload[:commits].first[:message] = "a commit message with more than one ticket [##{@ticket.scoped_id}] [##{ticket2.scoped_id}]"

    expect {
      post :commit, :token => @key.token, :payload => JSON.generate(@payload)
      @ticket.reload
      ticket2.reload
    }.to change{@ticket.comments.count + ticket2.comments.count}.by(2)

    @ticket.comments.count.should eq(2)
    ticket2.comments.count.should eq(2)
  end

  it "preserves ticket states when assigning a commit message to a ticket" do
    feature = create(:feature)
    @ticket.feature = feature
    @ticket.save
    @ticket.feature.should_not be_nil
    post :commit, :token => @key.token, :payload => JSON.generate(@payload)
    @ticket.feature.id.should eq feature.id
  end

  context "with a commit message that provides extra attributes" do
    it "changes the assigned user" do
      user = create(:user)
      @project.memberships.create(:user_id => user.id)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{@ticket.scoped_id} assigned:#{user.email}]"
        post :commit, :token => @key.token, :payload => JSON.generate(@payload)
        @ticket.reload # required!
      end.to change{@ticket.comments.count}.by(1)

      @ticket.assignee.should eq(user)
    end

    it "changes the assigned cost" do
      @ticket.cost.should_not eq(3)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{@ticket.scoped_id} cost:3]"
        post :commit, :token => @key.token, :payload => JSON.generate(@payload)
        @ticket.reload # required!
      end.to change{@ticket.comments.count}.by(1)

      @ticket.cost.should eq(3)
    end

    it "changes the assigned sprint" do
      sprint = create(:sprint, :project => @project)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{@ticket.scoped_id} sprint:#{sprint.scoped_id}]"
        post :commit, :token => @key.token, :payload => JSON.generate(@payload)
        @ticket.reload # required!
      end.to change{@ticket.comments.count}.by(1)

      @ticket.sprint.should eq(sprint)
    end

    it "changes the assigned feature" do
      feature = create(:feature, :project => @project)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{@ticket.scoped_id} feature:#{feature.scoped_id}]"
        post :commit, :token => @key.token, :payload => JSON.generate(@payload)
        @ticket.reload # required!
      end.to change{@ticket.comments.count}.by(1)

      @ticket.feature.should eq(feature)
    end

    it "changes the assigned status" do
      status = create(:ticket_status, :project => @project)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{@ticket.scoped_id} status:#{status.name}]"
        post :commit, :token => @key.token, :payload => JSON.generate(@payload)
        @ticket.reload # required!
      end.to change{@ticket.comments.count}.by(1)

      @ticket.status.should eq(status)
    end

    it "changes more than one assigned attribute at a time" do
      status = create(:ticket_status, :project => @project)
      @ticket.cost.should_not eq(3)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{@ticket.scoped_id} cost:3 status:#{status.name}]"
        post :commit, :token => @key.token, :payload => JSON.generate(@payload)
        @ticket.reload # required!
      end.to change{@ticket.comments.count}.by(1)

      @ticket.cost.should eq(3)
      @ticket.status.should eq(status)
    end

    it "ignores superfluous content in the comment (non key:value)" do
      status = create(:ticket_status, :project => @project)
      @ticket.cost.should_not eq(3)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{@ticket.scoped_id} and some cost:3 other rubbish]"
        post :commit, :token => @key.token, :payload => JSON.generate(@payload)
        @ticket.reload # required!
      end.to change{@ticket.comments.count}.by(1)

      @ticket.cost.should eq(3)
    end
  end

  it "should assign the commenter to the comment" do
    post :commit, :token => @key.token, :payload => JSON.generate(@payload)
    @ticket.reload
    @ticket.last_comment.commenter.should eq(@user.email)
  end

  it "should not add the same comment to a ticket twice" do
    expect do
      post :commit, :token => @key.token, :payload => JSON.generate(@payload)
      post :commit, :token => @key.token, :payload => JSON.generate(@payload)
    end.to change{@ticket.comments.count}.by(1)
  end

  it "should not assign a user to the new comment" do
    @ticket.comments.last.user.should_not be_nil
    post :commit, :token => @key.token, :payload => JSON.generate(@payload)
    @ticket.reload
    @ticket.comments.last.user.should be_nil
  end

  it "should create a comment with the commit date as the create_at date" do
    timestring = 5.days.ago.to_s
    @payload[:commits].first[:timestamp] = timestring
    expect do
      post :commit, :token => @key.token, :payload => JSON.generate(@payload)
      @ticket.reload
    end.to change{@ticket.comments.count}.by(1)
    @ticket.comments.last.created_at.should eq(timestring)
  end

end
