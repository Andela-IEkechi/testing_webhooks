# search is available in the following formats
# -- user enters any string with spaces
#    * performs a ransack search on any of the TICKET_KEYWORDS_MAP attributes
# -- user enters attribute:term string (can be multiple)
#    * performs a ransack search on only the matching attribute(s) using "and" condtion
# -- user enters attribute:term string seperated by " or " (can be multiple)
#    * performs a ransack search on only the matching attribute(s) using "or" condtion
class RansackHelper
  TICKET_KEYWORDS_MAP = {
    :id       => :scoped_id_eq,
    :cost     => :last_comment_cost_eq,
    :title    => :title_cont,
    :assigned => :assignee_email_cont,
    :status   => :status_name_cont,
    :feature  => :feature_title_cont,
    :sprint   => :sprint_goal_cont,
  }.freeze

  def initialize(query)
      @query        = query
      @term         = @query.values.first if @query
      @all_terms    = TICKET_KEYWORDS_MAP.map{ |k,v| {v => @term} }.to_a if @term
      @search_terms = @term.scan(/(\w+):(\w+)/).map{ |k,v| {TICKET_KEYWORDS_MAP[k.to_sym] => v} } if @term
  end

  def predicates
    return nil unless @query

    label_search_with_or  ||
    label_search_with_and ||
    basic_search
  end

  private

  def ransack_group(method, group)
    # one ransack group with multiple conditions. the method can be
    # either "or" / "and" and controls how condtions are where'd in sql
    # e.g. this turns "title:wildthings title:insomersetwest"
    # into (title like '%wildthings%' AND title like '%insomersetwest%')
    # e.g. this turns "title:tightasses or title:bigoltities"
    # into (title like '%tightasses%' OR title like '%bigoltities%')
    {
      m: method,
      g: group
    }
  end

  def basic_search
    ransack_group('or', @all_terms)
  end

  def label_search_with_and
    return nil unless @term.match(":")
    ransack_group('and', @search_terms)
  end

  def label_search_with_or
    return nil unless @term.match(":") && @term.match(" or ")
    ransack_group('or', @search_terms)
  end
end