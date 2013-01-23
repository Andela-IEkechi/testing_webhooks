require 'spec_helper'

describe GithubController, :focus => true do

  before :each do
    @project = create(:project)
    @ticket = create(:ticket, :project => @project)
    @user    = create(:user)
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
    #'/github/commit/1'
    expect do
      post :commit, :project_id => @project.id, "payload" => JSON(@payload)
    end.to change{@ticket.comments.count}.from(0).to(1)
  end

  it 'assigns a commit message to a multiple tickets' do
    ticket2 = create(:ticket, :project => @project)
    @payload[:commits].first[:message] = "a commit message with more than one ticket [##{@ticket.scoped_id}] [##{ticket2.scoped_id}]"

    expect do
      post :commit, :project_id => @project.id, "payload" => JSON(@payload)
    end.to change{@ticket.comments.count + ticket2.comments.count}.from(0).to(2)

    @ticket.comments.count.should eq(1)
    ticket2.comments.count.should eq(1)

    p "#{@ticket.comments.first.body}"

  end

end
