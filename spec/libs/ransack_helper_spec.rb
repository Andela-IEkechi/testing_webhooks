require 'spec_helper'

describe RansackHelper do
  before(:all) do
    @user    = create(:user)
    @project = create(:project, user: @user)
    @sprint  = create(:sprint, project: @project, goal: 'sprint-xxx')
    @feature = create(:feature, project: @project, title: 'feature-xxx')
    @ticket  = create(:ticket, title: 'lonesome', project: @project)
    @comment = create(:comment, ticket: @ticket, sprint: @sprint, feature: @feature, assignee: @user, cost: 3, status: @status)

    @ticket.reload
    @scoped_tickets = @project.tickets

    TEST_MAP = {
      id:       @ticket.scoped_id.to_s,
      cost:     @comment.cost.to_s,
      title:    @ticket.title,
      assignee: @user.email,
      assigned: @user.email,
      state:    @ticket.status.name,
      status:   @ticket.status.name,
      feature:  @feature.title,
      sprint:   @sprint.goal
    }
  end

  it "define TICKET_KEYWORDS_MAP as a hash of keyword types" do
    RansackHelper::TICKET_KEYWORDS_MAP.should_not be_nil
    RansackHelper::TICKET_KEYWORDS_MAP.try(:keys).should_not be_nil
  end

  it "define KEYWORDS_MAP as an array of keywords" do
    RansackHelper::TICKET_KEYWORDS.should_not be_nil
    RansackHelper::TICKET_KEYWORDS.should_not be_empty
  end

  context "search for tickets" do
    RansackHelper::TICKET_KEYWORDS_MAP.each do |k,v|
      it "filtered by #{k}" do
        term = TEST_MAP[k]

        # we know what presicates must look like
        predicates = RansackHelper.new("#{k}:#{term}").predicates
        predicates.should == {m: 'and', g: [{v => term}]}

        # we know it must always return one record
        @scoped_tickets.search(predicates).result.size.should == 1
      end

      it "filtered by a value" do
        term = TEST_MAP[k]

        # we know it must always return one record
        predicates = RansackHelper.new(term).predicates
        puts predicates
        @scoped_tickets.search(predicates).result.size.should == 1
      end

      it "filtered by #{k} and something else using OR" do
        term = TEST_MAP[k]

        # test OR searches using unknown values
        predicates = RansackHelper.new("#{k}:#{term} OR #{k}:xxxx").predicates
        @scoped_tickets.search(predicates).result.size.should == 0


        # test OR searches using known values
        key = RansackHelper::TICKET_KEYWORDS_MAP.except(k).keys.sample
        predicates = RansackHelper.new("#{k}:#{term} OR #{key}:#{TEST_MAP[key]}").predicates
        @scoped_tickets.search(predicates).result.size.should == 1
      end

      it "filtered by #{k} and something else using AND" do
        term = TEST_MAP[k]

        # test OR searches using unknown values
        predicates = RansackHelper.new("#{k}:#{term} AND #{k}:xxxx").predicates
        @scoped_tickets.search(predicates).result.size.should == 0


        # test OR searches using known values
        key = RansackHelper::TICKET_KEYWORDS_MAP.except(k).keys.sample
        predicates = RansackHelper.new("#{k}:#{term} AND #{key}:#{TEST_MAP[key]}").predicates
        @scoped_tickets.search(predicates).result.size.should == 1
      end

      it "filtered by #{k} and something else using AND and OR" do
        term = TEST_MAP[k]

        # test OR searches using unknown values
        predicates = RansackHelper.new("#{k}:#{term} AND #{k}:xxxx OR #{k}:yyyy").predicates
        @scoped_tickets.search(predicates).result.size.should == 0


        # test OR searches using known values
        key1 = RansackHelper::TICKET_KEYWORDS_MAP.except(k).keys.sample
        key2 = RansackHelper::TICKET_KEYWORDS_MAP.except(k).keys.sample
        predicates = RansackHelper.new("#{k}:#{term} AND #{key1}:#{TEST_MAP[key1]} OR #{key2}:#{TEST_MAP[key2]}").predicates
        @scoped_tickets.search(predicates).result.size.should == 1
      end
    end
  end
end