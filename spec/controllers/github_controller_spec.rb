require 'spec_helper'

describe GithubController, focus: true do

  before :each do
    @project = create(:project)
    @user    = create(:user)

    @ticket = create(:ticket, :project => @project)
    #we have to add a comment to the ticket, the factory does not because it sticks to the model's rules, not the business logic
    @ticket.comments << create(:comment, :ticket => @ticket, :user=>@user)

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
    expect do
      post :commit, :token => @key.token, "payload" => JSON(@payload)
    end.to change{@ticket.comments.count}.from(1).to(2)
  end

  it 'assigns a commit message to a multiple tickets' do
    ticket2 = create(:ticket, :project => @project)
    ticket2.comments << create(:comment, :user => @user, :ticket => ticket2)

    @payload[:commits].first[:message] = "a commit message with more than one ticket [##{@ticket.scoped_id}] [##{ticket2.scoped_id}]"

    expect do
      post :commit, :token => @key.token, "payload" => JSON(@payload)
    end.to change{@ticket.comments.count + ticket2.comments.count}.from(2).to(4)

    @ticket.comments.count.should eq(2)
    ticket2.comments.count.should eq(2)
  end

  it "preserves ticket states when assigning a commit message to a ticket" do
    feature = create(:feature)
    @ticket.feature = feature
    @ticket.save
    @ticket.feature.should_not be_nil
    post :commit, :token => @key.token, "payload" => JSON(@payload)
    @ticket.feature.id.should eq feature.id
  end

  it "should assign the commenter to the comment" do
    post :commit, :token => @key.token, "payload" => JSON(@payload)
    @ticket.reload
    @ticket.last_comment.commenter.should eq(@user.email)
  end

  it "should not add the same comment to ticket twice" do
    expect do
      post :commit, :token => @key.token, "payload" => JSON(@payload)
      post :commit, :token => @key.token, "payload" => JSON(@payload)
    end.to change{@ticket.comments.count}.from(1).to(2)
  end

  it "should not assign a user to the new comment" do
    @ticket.comments.last.user.should_not be_nil
    post :commit, :token => @key.token, "payload" => JSON(@payload)
    @ticket.reload
    @ticket.comments.last.user.should be_nil
  end
end
