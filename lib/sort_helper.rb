# search is available in the following formats
# -- user enters any string with spaces
#    * performs a ransack search on any of the TICKET_KEYWORDS_MAP attributes
# -- user enters attribute:term string (can be multiple)
#    * performs a ransack search on only the matching attribute(s) using "and" condtion
# -- user enters attribute:term string seperated by " or " (can be multiple)
#    * performs a ransack search on only the matching attribute(s) using "or" condtion
class SortHelper
  SORT_KEYWORDS_MAP = {
    id:       'tickets.id',
    cost:     'comments.cost',
    title:    'tickets.title',
    assignee: 'users.email',
    assigned: 'users.email',
    state:    'ticket_statuses.name',
    status:   'ticket_statuses.name',
    feature:  'features.title',
    sprint:   'sprints.goal'
  }.freeze

  SORT_KEYWORDS = SORT_KEYWORDS_MAP.keys.map(&:to_s).freeze

  def initialize(term, direction="ASC")
    @direction = direction
    @sort_terms = []
    return unless term
    @sort_matches = term.downcase.scan(/[sort|order]:([\w@\-\.]+)/i).flatten unless term.blank?
    @sort_terms = @sort_matches.collect{ |s| SORT_KEYWORDS_MAP[s.to_sym] }.compact.map{|s| [s, direction].join(' ')}.compact if @sort_matches
  end

  def sort_terms
    @sort_terms
  end

  def sort_order
    @sort_terms << "tickets.id #{@direction}"
    return @sort_terms.join(',')
  end

  def direction
    @direction
  end
end
