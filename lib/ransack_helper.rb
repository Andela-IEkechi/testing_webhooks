# search is available in the following formats
# -- user enters any string with spaces
#    * performs a ransack search on any of the TICKET_KEYWORDS_MAP attributes
# -- user enters attribute:term string (can be multiple)
#    * performs a ransack search on only the matching attribute(s) using "and" condtion
# -- user enters attribute:term string seperated by " or " (can be multiple)
#    * performs a ransack search on only the matching attribute(s) using "or" condtion
class RansackHelper
  TICKET_KEYWORDS_MAP = {
    id:       :scoped_id_eq,
    cost:     :last_comment_cost_eq,
    title:    :title_cont,
    assignee: :assignee_email_cont,
    assigned: :assignee_email_cont,
    state:    :status_name_cont,
    status:   :status_name_cont,
    feature:  :feature_title_cont,
    sprint:   :sprint_goal_cont
  }.freeze

  TICKET_KEYWORDS = TICKET_KEYWORDS_MAP.keys.map(&:to_s).freeze

  def initialize(term)
    return unless term

    @search_term  = term.blank? ? nil : term
    @search_terms = @search_term.scan(/([\w@\-\.]+):([\w@\-\.]+)/i) if @search_term
    @mapped_terms = @search_terms.map{ |k,v| {TICKET_KEYWORDS_MAP[k.to_sym] => v} } if @search_terms
    #reject {nil => 'somevalue'} keys we cant use (did not recognise)
    @mapped_terms.reject!{|t| t.keys.first.nil?} if @mapped_terms
  end

  def predicates
    return unless valid_search

    label_search_with_and_or ||
    label_search_with_or     ||
    label_search_with_and    ||
    basic_search
  end

  private

  def basic_search
    Rails.logger.debug "SEARCH# search using basic_search: #{@search_term}"
    ransack_group('or', all_terms)
  end

  def label_search_with_and
    return unless @search_term.match(":")

    Rails.logger.debug "SEARCH# search using label_search_with_and: #{@search_term}"
    ransack_group('and', @mapped_terms)
  end

  def label_search_with_or
    return unless @search_term.match(":") && @search_term.match(" or ")

    Rails.logger.debug "SEARCH# search using label_search_with_or: #{@search_term}"
    ransack_group('or', @mapped_terms)
  end

  # for no we only support multiple or'd conditions. later on we will allow
  # brackets for more flexibility.
  # e.g this turns "assignee:angus AND status:new OR status:open"
  # into ((assignee like '%angus%') AND (status like '%new%' OR status like '%open%'))
  # e.g this turns "assignee:jean AND assignee:angus AND status:new OR status:open"
  # into ((assignee like '%angus%' OR assignee like '%jean%') AND (status like '%new%' OR status like '%open%'))
  def label_search_with_and_or
    return unless @search_term.match(":") && @search_term.match(" or ") && @search_term.match(" and ")

    Rails.logger.debug "SEARCH# search using label_search_with_and_or: #{@search_term}"
    @anded_terms = @search_term.scan(/(.+) and (.+)/i).flatten
    multiple_ransack_groups @anded_terms.map{ |term| RansackHelper.new(term).predicates }
  end

  # we need to make sure they pass a valid search term else ransack
  # doesnt know what to do. Need to make sure search format keyword:term
  # has a valid keyword too.
  def valid_search
    return false unless @search_term
    return false if @search_term.match(":") && (@search_terms.map(&:first) & TICKET_KEYWORDS).empty?
    true
  end

  # the default db value for cost is 0. If you search an integer field with
  # a string e.g. "xxx" ransack just makes it 0. That kills search as tickets
  # with default cost are returned. Unless users search for an integer
  # we make the term for cost -1.
  def all_terms
    return unless @search_term

    terms_hash = {}
    TICKET_KEYWORDS_MAP.each { |k,v| terms_hash[v] = @search_term }
    terms_hash.delete(:last_comment_cost_eq) unless @search_term.integer?
    terms_hash.delete(:scoped_id_eq) unless @search_term.integer?
    terms_hash.collect {|k, v| {k => v}}
  end

  # one ransack group with multiple conditions. the method can be
  # either "or" / "and" and controls how condtions are where'd in sql
  # e.g. this turns "title:wildthings title:insomersetwest"
  # into (title like '%wildthings%' AND title like '%insomersetwest%')
  # e.g. this turns "title:tightasses or title:bigoltities"
  # into (title like '%tightasses%' OR title like '%bigoltities%')
  def ransack_group(method, group)
    {
      m: method,
      g: group
    }
  end

  # match multiple seperate conditions
  def multiple_ransack_groups(ransack_groups)
    {
      g: ransack_groups
    }
  end
end