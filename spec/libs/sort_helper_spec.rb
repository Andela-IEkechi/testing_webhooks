require 'spec_helper'

describe SortHelper, :focus do
  it "should contruct from a search string" do
    sort = SortHelper.new("sort:#{SortHelper::SORT_KEYWORDS.first}")
    sort.should_not be_nil
  end

  it "should ignore superflous parts" do
    sort = SortHelper.new("some stuff before sort:#{SortHelper::SORT_KEYWORDS.first} some other stuff after")
    sort.should_not be_nil
    sort.sort_terms.should have(1).entry
  end

  it "should accept 'order'" do
    sort = SortHelper.new("order:#{SortHelper::SORT_KEYWORDS.first}")
    sort.should_not be_nil
    sort.sort_terms.should have(1).entry
  end

  it  "should accept 'sort'" do
    sort = SortHelper.new("sort:#{SortHelper::SORT_KEYWORDS.first}")
    sort.should_not be_nil
    sort.sort_terms.should have(1).entry
  end

  it "should respond to #sort_terms" do
    sort = SortHelper.new('')
    sort.should respond_to(:sort_terms)
  end

  it "should respond to #sort_order" do
    sort = SortHelper.new('')
    sort.should respond_to(:sort_order)
  end

  context "for valid sort directives" do
    SortHelper::SORT_KEYWORDS.each do |term|
      it "should have the term in the list of terms" do
        @sort = SortHelper.new("sort:#{term}")
        @sort.sort_terms.should have(1).entry
        @sort.sort_order.should eq(SortHelper::SORT_KEYWORDS_MAP[term.to_sym])
      end

      it "should be a valid sorting clause" do
        @sort = SortHelper.new("sort:#{term}")
        ticket = create(:ticket)
        ticket.project.tickets.all.should have(1).entry
        ticket.project.tickets.includes(:last_comment => [:sprint, :feature, :assignee, :status]).all.should have(1).entry
        ticket.project.tickets.includes(:last_comment => [:sprint, :feature, :assignee, :status]).order(@sort.sort_order).all.should have(1).entry
      end
    end
  end

  it "should combine sort terms" do
    terms = SortHelper::SORT_KEYWORDS.sample(2)
    @sort = SortHelper.new(terms.collect{|t| "sort:#{t}"}.join(' '))
    @sort.sort_order.should eq(terms.collect{|t| SortHelper::SORT_KEYWORDS_MAP[t.to_sym]}.join(','))
  end

  it "should ignore the invalid sort" do
  end

end
