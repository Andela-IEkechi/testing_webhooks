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
    assigned: :assignee_email_cont,
    status:   :status_name_cont,
    feature:  :feature_title_cont,
    sprint:   :sprint_goal_cont
  }.freeze

  def initialize(query)
      @search_term  = (query.values.first.blank? ? nil : query.values.first) if query
      @mapped_terms = @search_term.scan(/(\w+):(\w+)/).map{ |k,v| {TICKET_KEYWORDS_MAP[k.to_sym] => v} } if @search_term
  end

  def predicates
    return nil unless @search_term

    label_search_with_or  ||
    label_search_with_and ||
    basic_search
  end

  private

  # the default db value for cost is 0. If you search an integer field with
  # a string e.g. "xxx" ransack just makes it 0. That kills search as tickets
  # with default cost are returned. Unless users search for an integer
  # we make the term for cost -1.
  def all_terms
    return unless @search_term

    terms = TICKET_KEYWORDS_MAP.map{ |k,v| {v => @search_term} }
    terms.map!{ |t| t.has_key?(:last_comment_cost_eq) ? {last_comment_cost_eq: -1} : t } unless @search_term.integer?
    terms
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

  def basic_search
    ransack_group('or', all_terms)
  end

  def label_search_with_and
    return nil unless @search_term.match(":")
    ransack_group('and', @mapped_terms)
  end

  def label_search_with_or
    return nil unless @search_term.match(":") && @search_term.match(" or ")
    ransack_group('or', @mapped_terms)
  end
end