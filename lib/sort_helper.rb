# search is available in the following formats
# -- user enters any string with spaces
#    * performs a ransack search on any of the TICKET_KEYWORDS_MAP attributes
# -- user enters attribute:term string (can be multiple)
#    * performs a ransack search on only the matching attribute(s) using "and" condtion
# -- user enters attribute:term string seperated by " or " (can be multiple)
#    * performs a ransack search on only the matching attribute(s) using "or" condtion
class SortHelper
  SORT_KEYWORDS_MAP = {
    id:       'tickets.id ASC',
    cost:     'comments.cost ASC',
    title:    'tickets.title ASC',
    assignee: 'users.email ASC',
    assigned: 'users.email ASC',
    state:    'ticket_statuses.name ASC',
    status:   'ticket_statuses.name ASC',
    feature:  'features.title ASC',
    sprint:   'sprints.goal ASC'
  }.freeze

  SORT_KEYWORDS = SORT_KEYWORDS_MAP.keys.map(&:to_s).freeze

  def initialize(term)
    @sort_terms = []
    return unless term
    @sort_matches = term.downcase.scan(/[sort|order]:([\w@\-\.]+)/i).flatten unless term.blank?
    @sort_terms = @sort_matches.collect{ |s| SORT_KEYWORDS_MAP[s.to_sym] }.compact if @sort_matches
  end

  def sort_terms
    @sort_terms
  end

  def sort_order
    return @sort_terms.join(',')
  end
end