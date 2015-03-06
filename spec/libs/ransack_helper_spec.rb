require 'spec_helper'

describe RansackHelper do
  before(:each) do
    @user    = create(:user)
    @project = create(:project, user: @user)
    @sprint  = create(:sprint, project: @project, goal: 'sprint-xxx')
    @feature = create(:feature, project: @project, title: 'feature-xxx')
    @ticket  = create(:ticket, title: 'lonesome', project: @project)
    @comment = create(:comment, ticket: @ticket, sprint: @sprint, feature: @feature, assignee: @user, cost: 3, status: @project.ticket_statuses.first)
    @asset   = create(:asset, :project => @project, :sprint => @sprint, :feature => @feature)

    filename = "#{Rails.root}/spec/data/dummy.file"
    @asset.payload = FileUploader.new(@asset, :file)
    @asset.payload.store!(File.open(filename))
    @asset.save

    @ticket.reload
    @scoped_tickets = @project.tickets
    @scoped_assets = @project.assets

    @test_map = {
      :id => @ticket.scoped_id.to_s,
      :cost => @comment.cost.to_s,
      :title => @ticket.title,
      :assignee => @user.email,
      :assigned => @user.email,
      :state => @ticket.status.name,
      :status => @ticket.status.name,
      :feature => @feature.title,
      :sprint => @sprint.goal,
      :payload => @asset.name
    }
  end

  describe "constants" do
    it "define TICKET_KEYWORDS_MAP as a hash of keyword types" do
      expect(RansackHelper::TICKET_KEYWORDS_MAP).to_not be_nil
      expect(RansackHelper::TICKET_KEYWORDS_MAP.try(:keys)).to_not be_nil
    end

    it "define TICKET_KEYWORDS_MAP as a hash of keyword types" do
      expect(RansackHelper::ASSET_KEYWORDS_MAP).to_not be_nil
      expect(RansackHelper::ASSET_KEYWORDS_MAP.try(:keys)).to_not be_nil
    end

    it "define KEYWORDS_MAP as an array of keywords" do
      expect(RansackHelper::TICKET_KEYWORDS).to_not be_nil
      expect(RansackHelper::TICKET_KEYWORDS).to_not be_empty
    end
  end

  context "search for tickets by keyword" do
    RansackHelper::TICKET_KEYWORDS_MAP.each do |k,v|
      it "filtered by #{k}" do
        term = @test_map[k]

        # we know what predicates must look like
        predicates = RansackHelper.new("#{k}:#{term}").predicates
        expect(predicates).to eq({m: 'and', g: [{v => term}]})

        # we know it must always return one record
        expect(@scoped_tickets.search(predicates).result.size).to eq(1)
      end

      it "filtered by a value" do
        term = @test_map[k]

        # we know it must always return one record
        predicates = RansackHelper.new(term).predicates
        expect(@scoped_tickets.search(predicates).result.size).to eq(1)
      end

      it "filtered by #{k} and something else using OR" do
        term = @test_map[k]

        # test OR searches using unknown values
        predicates = RansackHelper.new("#{k}:#{term} OR #{k}:xxxx").predicates
        expect(@scoped_tickets.search(predicates).result.size).to eq(0)


        # test OR searches using known values
        key = RansackHelper::TICKET_KEYWORDS_MAP.except(k).keys.sample
        predicates = RansackHelper.new("#{k}:#{term} OR #{key}:#{@test_map[key]}").predicates
        expect(@scoped_tickets.search(predicates).result.size).to eq(1)
      end

      it "filtered by #{k} and something else using AND" do
        term = @test_map[k]

        # test AND searches using unknown values
        predicates = RansackHelper.new("#{k}:#{term} AND #{k}:xxxx").predicates
        expect(@scoped_tickets.search(predicates).result.size).to eq(0)


        # test AND searches using known values
        key = RansackHelper::TICKET_KEYWORDS_MAP.except(k).keys.sample
        predicates = RansackHelper.new("#{k}:#{term} AND #{key}:#{@test_map[key]}").predicates
        expect(@scoped_tickets.search(predicates).result.size).to eq(1)
      end

      it "filtered by #{k} and something else using AND and OR" do
        term = @test_map[k]

        # test AND/OR searches using unknown values
        predicates = RansackHelper.new("#{k}:#{term} AND #{k}:xxxx OR #{k}:yyyy").predicates
        expect(@scoped_tickets.search(predicates).result.size).to eq(0)

        # test AND/OR searches using known values
        key1 = RansackHelper::TICKET_KEYWORDS_MAP.except(k).keys.sample
        key2 = RansackHelper::TICKET_KEYWORDS_MAP.except(k).keys.sample
        predicates = RansackHelper.new("#{k}:#{term} AND #{key1}:#{@test_map[key1]} OR #{key2}:#{@test_map[key2]}").predicates
        expect(@scoped_tickets.search(predicates).result.size).to eq(1)
      end
    end
  end

  context "search for assets by keyword" do
    RansackHelper::ASSET_KEYWORDS_MAP.each do |k,v|
      it "filtered by #{k}" do
        term = @test_map[k]

        # we know what predicates must look like
        predicates = RansackHelper.new("#{k}:#{term}", :assets).predicates
        expect(predicates).to eq({m: 'and', g: [{v => term}]})

        # we know it must always return one record
        expect(@scoped_assets.search(predicates).result.size).to eq(1)
      end

      it "filtered by a value" do
        term = @test_map[k]

        # we know it must always return one record
        predicates = RansackHelper.new(term, :assets).predicates
        expect(@scoped_assets.search(predicates).result.size).to eq(1)
      end

      it "filtered by #{k} and something else using OR" do
        term = @test_map[k]

        # test OR searches using unknown values
        predicates = RansackHelper.new("#{k}:#{term} OR #{k}:xxxx", :assets).predicates
        expect(@scoped_assets.search(predicates).result.size).to eq(0)


        # test OR searches using known values
        key = RansackHelper::ASSET_KEYWORDS_MAP.except(k).keys.sample
        predicates = RansackHelper.new("#{k}:#{term} OR #{key}:#{@test_map[key]}", :assets).predicates
        expect(@scoped_assets.search(predicates).result.size).to eq(1)
      end

      it "filtered by #{k} and something else using AND" do
        term = @test_map[k]

        # test AND searches using unknown values
        predicates = RansackHelper.new("#{k}:#{term} AND #{k}:xxxx", :assets).predicates
        expect(@scoped_assets.search(predicates).result.size).to eq(0)


        # test AND searches using known values
        key = RansackHelper::ASSET_KEYWORDS_MAP.except(k).keys.sample
        predicates = RansackHelper.new("#{k}:#{term} AND #{key}:#{@test_map[key]}", :assets).predicates
        expect(@scoped_assets.search(predicates).result.size).to eq(1)
      end

      it "filtered by #{k} and something else using AND and OR" do
        term = @test_map[k]

        # test AND/OR searches using unknown values
        predicates = RansackHelper.new("#{k}:#{term} AND #{k}:xxxx OR #{k}:yyyy", :assets).predicates
        expect(@scoped_assets.search(predicates).result.size).to eq(0)

        # test AND/OR searches using known values
        key1 = RansackHelper::ASSET_KEYWORDS_MAP.except(k).keys.sample
        key2 = RansackHelper::ASSET_KEYWORDS_MAP.except(k).keys.sample
        predicates = RansackHelper.new("#{k}:#{term} AND #{key1}:#{@test_map[key1]} OR #{key2}:#{@test_map[key2]}", :assets).predicates
        expect(@scoped_assets.search(predicates).result.size).to eq(1)
      end
    end
  end
end
