require 'spec_helper'

describe GithubController, :type => :controller do
  let(:project) {create(:project)}
  let(:user) {create(:user)}
  let(:ticket) {create(:ticket, :project => project)}
  let(:key) {create(:api_key, :project => project)}

  before :each do
    project.memberships.create(:user_id => user.id)

    #we have to add a comment to the ticket, the factory does not because it sticks to
    #the model's rules, not the business logic
    ticket.comments << create(:comment, :ticket => ticket, :user => user)

  	@payload = {
      after: "2d00bdaa3f0d41a3a9bc355eb38f6245e70d79a1",
      before: "4144b9ae4565cf74cbe6c1915123debbab1119bc",
      commits: [
        { added: [],
          author: {
            email: "#{user.email}",
            name: "elarex",
            username: "elarex" },
          committer: {
            email: "#{user.email}",
            name: "elarex",
            username: "elarex" },
          distinct: true,
          id: "bf73ba69c1f733fff5003527004b8806f899267d",
          message: "a commit message with one ticket: [##{ticket.scoped_id}]",
          modified: [ "app/views/comments/_form_fields.html.erb" ],
          removed: [],
          timestamp: (DateTime.now + 1.hour).to_s,
          url: "https://github.com/Shuntyard/Conductor/commit/bf73ba69c1f733fff5003527004b8806f899267d"
        }
      ]
    }
  end

  it 'assigns a commit message to a ticket' do
    expect {
      post :commit, :token => key.token, :payload => JSON.generate(@payload)
    }.to change{ticket.comments.count}.from(1).to(2)
  end

  it 'assigns a commit message to a multiple tickets' do
    ticket2 = create(:ticket, :project => project)
    ticket2.comments << create(:comment, :user => user, :ticket => ticket2)

    @payload[:commits].first[:message] = "a commit message with more than one ticket [##{ticket.scoped_id}] [##{ticket2.scoped_id}]"

    expect {
      post :commit, :token => key.token, :payload => JSON.generate(@payload)
      ticket.reload
      ticket2.reload
    }.to change{ticket.comments.count + ticket2.comments.count}.by(2)

    expect(ticket.comments.count).to eq(2)
    expect(ticket2.comments.count).to eq(2)
  end

  context "with a commit message that provides extra attributes" do
    it "changes the assigned user" do
      user = create(:user)
      project.memberships.create(:user_id => user.id)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{ticket.scoped_id} assigned:#{user.email}]"
        post :commit, :token => key.token, :payload => JSON.generate(@payload)
        ticket.reload # required!
      end.to change{ticket.comments.count}.by(1)

      expect(ticket.assignee).to eq(user)
    end

    it "changes the assigned cost" do
      expect(ticket.cost).to_not eq(3)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{ticket.scoped_id} cost:3]"
        post :commit, :token => key.token, :payload => JSON.generate(@payload)
        ticket.reload # required!
      end.to change{ticket.comments.count}.by(1)

      expect(ticket.cost).to eq(3)
    end

    it "changes the assigned sprint" do
      sprint = create(:sprint, :project => project)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{ticket.scoped_id} sprint:#{sprint.scoped_id}]"
        post :commit, :token => key.token, :payload => JSON.generate(@payload)
        ticket.reload # required!
      end.to change{ticket.comments.count}.by(1)

      expect(ticket.sprint).to eq(sprint)
    end

    it "changes the assigned status" do
      status = create(:ticket_status, :project => project)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{ticket.scoped_id} status:#{status.name}]"
        post :commit, :token => key.token, :payload => JSON.generate(@payload)
        ticket.reload # required!
      end.to change{ticket.comments.count}.by(1)

      expect(ticket.status).to eq(status)
    end

    it "changes more than one assigned attribute at a time" do
      status = create(:ticket_status, :project => project)
      expect(ticket.cost).to_not eq(3)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{ticket.scoped_id} cost:3 status:#{status.name}]"
        post :commit, :token => key.token, :payload => JSON.generate(@payload)
        ticket.reload # required!
      end.to change{ticket.comments.count}.by(1)

      expect(ticket.cost).to eq(3)
      expect(ticket.status).to eq(status)
    end

    it "ignores superfluous content in the comment (non key:value)" do
      status = create(:ticket_status, :project => project)
      expect(ticket.cost).to_not eq(3)
      expect do
        # Send a message with changes to all ticket attributes
        @payload[:commits].first[:message] = "sample data [##{ticket.scoped_id} and some cost:3 other rubbish]"
        post :commit, :token => key.token, :payload => JSON.generate(@payload)
        ticket.reload # required!
      end.to change{ticket.comments.count}.by(1)

      expect(ticket.cost).to eq(3)
    end
  end

  it "should assign the commenter to the comment" do
    post :commit, :token => key.token, :payload => JSON.generate(@payload)
    ticket.reload
    expect(ticket.last_comment.commenter).to eq(user.email)
  end

  it "should not add the same comment to a ticket twice" do
    expect do
      post :commit, :token => key.token, :payload => JSON.generate(@payload)
      post :commit, :token => key.token, :payload => JSON.generate(@payload)
    end.to change{ticket.comments.count}.by(1)
  end

  it "assigns a user to the new comment" do
    expect(ticket.comments.last.user).to_not be_nil
    post :commit, :token => key.token, :payload => JSON.generate(@payload)
    ticket.reload
    expect(ticket.comments.last.user.id).to eq(user.id)
  end

  it "creates a comment in the right cronological order" do
    #create a GH comment which precedes first comment (out of order)
    timestring = ticket.last_comment.created_at - 5.seconds
    first_comment_id = ticket.last_comment.id
    @payload[:commits].first[:timestamp] = timestring
    expect do
      post :commit, :token => key.token, :payload => JSON.generate(@payload)
      ticket.reload
    end.to change{ticket.comments.count}.by(1)
    #the new "older" comment should still be treated as the most recent comment on the ticket.
    expect(ticket.last_comment.id).not_to eq(first_comment_id)
  end

end
