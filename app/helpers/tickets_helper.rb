module TicketsHelper

  TICKET_KEYWORDS_MAP = {
    :id => :scoped_id_equals,
    :title => :title_contains,
    :assigned => :assignee_email_contains,
    :status => :status_name_contains,
    :feature => :feature_title_contains,
    :sprint => :sprint_goal_contains,
    :cost => :last_comment_cost_equals }

  def search_query_to_hash(query)
    if query.match(":")
      hash = {}
      query.scan(/(\w+):(\w+)/){ |x,y| hash[x.to_sym] = y }
      output = {}
      hash.keys.each do |k|
        if TICKET_KEYWORDS_MAP.keys.include? k
          output[TICKET_KEYWORDS_MAP[k]] = hash[k]
        end
      end
      return output
    else
      nil
    end
  end

  def cost_short(cost)
    case cost
    when 0
      "--"
    else
      cost.to_s
    end
  end

end
