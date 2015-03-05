require 'spec_helper'

describe SortHelper do
  let(:subject) {SortHelper.new('')}

  it {expect(subject).to respond_to(:sort_terms)}
  it {expect(subject).to respond_to(:sort_order)}


  describe "initializer" do
    it "constructs from a search string" do
      sort = SortHelper.new("sort:#{SortHelper::SORT_KEYWORDS.first}")
      expect(sort).to_not be_nil
    end

    it "constructs from a search string and direction" do
      sort = SortHelper.new("sort:#{SortHelper::SORT_KEYWORDS.first}", "ASC")
      expect(sort).to_not be_nil
    end

    it "has default ASC direction" do
      sort = SortHelper.new("sort:#{SortHelper::SORT_KEYWORDS.first}")
      expect(sort.direction).to eq('ASC')
    end

    it "should ignore superflous parts" do
      sort = SortHelper.new("some stuff before sort:#{SortHelper::SORT_KEYWORDS.first} some other stuff after")
      expect(sort.sort_terms.count).to eq(1)
    end
  end

  describe "keywords" do
    it "accepts 'order'" do
      sort = SortHelper.new("order:#{SortHelper::SORT_KEYWORDS.first}")
      expect(sort.sort_terms.count).to eq(1)
    end

    it  "accepts 'sort'" do
      sort = SortHelper.new("sort:#{SortHelper::SORT_KEYWORDS.first}")
      expect(sort.sort_terms.count).to eq(1)
    end
  end

  context "for valid sort directives" do
    SortHelper::SORT_KEYWORDS.each do |term|
      it "has the term in the list of terms" do
        @sort = SortHelper.new("sort:#{term}")
        expect(@sort.sort_order).to match(SortHelper::SORT_KEYWORDS_MAP[term.to_sym])
      end

      it "has a valid sorting clause" do
        @sort = SortHelper.new("sort:#{term}")
        ticket = create(:ticket)
        scope = ticket.project.tickets.includes(:last_comment => [:sprint, :feature, :assignee, :status])
        expect(scope.count).to eq(1)
        expect(scope.order(@sort.sort_order).count).to eq(1)
      end
    end
  end

  describe "sort terms" do
    it "combines" do
      terms = SortHelper::SORT_KEYWORDS.sample(2)
      @sort = SortHelper.new(terms.collect{|t| "sort:#{t}"}.join(' '))
      terms << 'id'
      @sort.sort_order.should eq(terms.collect{|t| "#{SortHelper::SORT_KEYWORDS_MAP[t.to_sym]} ASC"}.join(','))
    end

    it "defaults to tickets.id" do
      terms = ['id']
      @sort = SortHelper.new('')
      @sort.sort_order.should eq("tickets.id ASC")
    end

    it "should ignore the invalid sort"
  end

end
