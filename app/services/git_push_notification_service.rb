class GitPushNotificationService

  def initialize params
    @params = params
  end

  def make_into_comment
    if api_key = ApiKey.find_by_access_key(@params["token"])
      @project = api_key.project
      payload = JSON.parse(@params["payload"]) rescue {}
      Rails.logger.info "GitHub payload: #{payload}"
      extract_attributes(payload, api_key)
    end
    Rails.logger.info "Successfully Posted Comment!"
  end

  def extract_attributes payload, api_key
    payload["commits"].each do |commit|
      commit = commit.with_indifferent_access

      if Comment.find_all_by_git_commit_uuid(commit["id" ]).count == 0
        commit_msg = commit["message"]

        commit_msg.scan(/\[#(\d+)([^\]]*)\]/).each do |ticket_ref, others|
          #find the ticket the matches
          ticket = @project.tickets.find_by_scoped_id(ticket_ref.to_i)
          if ticket
            #the committer might be a user we know about, so we try and find them
            commit_user = User.find_by_email(commit['author']['email']) rescue nil
            Rails.logger.info "Attributing commit to user: #{commit_user || 'Unknown'}"

            #set up the attrs we want to persist
            attributes = {
                message: commit_message(commit),
                api_key_name: api_key.name,
                commenter: commit_user,
                commit_uuid: commit['id'],
                user_id: (commit_user.try(:id))
                #we specifically use the regular created_at timestamp, so that new comments don't precede the normal ticket flow.
                #users with skewed timestamps can really mess with tickets' chronological flow
            }.with_indifferent_access

            #we need to append the attributes from this commit, to whatever was on the last comment. So we use reverse_merge
            if ticket.last_comment
              last_comment_attrs = ticket.last_comment.attributes.reject{ |k,v| %w(id created_at updated_at user_id).include?(k) }.with_indifferent_access
              attributes.reverse_merge!(last_comment_attrs)
            end

            add_settings_to_attributes(attributes, others, ticket)
            post_comment(ticket, attributes)
          else
            Rails.logger.info "Could not find ticket for reference: #{ticket_ref}"
          end
        end
      end
    end
  end

  def add_settings_to_attributes attributes, others, ticket
    attributes.merge!(comment_to_hash(others, ticket)) unless others.blank?
    attributes["tag_list"] ||= []
    attributes["tag_list"] += ticket.tag_list
  end

  def post_comment ticket, attributes
    ticket.comments.create!(attributes)
  end

  def commit_message(commit)
    "#{commit['message']}\n\n[View on GitHub](#{commit['url']})"
  end

  def comment_to_hash(others, ticket)
    attributes = {}
    others.scan(/([^\s]+):([^\s]+)/).collect do |key, value|
      case key
        when 'assigned', 'assigned', 'assignee', 'user'
          attributes['assignee_id'] = (ticket.project.members.by_email(value).first.user_id rescue nil)
        when 'board'
          attributes['board_id'] = (ticket.project.boards.find(value).id rescue nil)
        when 'status'
          attributes['status_id'] = (ticket.project.statuses.find_by_name(value).id rescue nil)
        when 'tag'
          attributes['tag_list'] ||= []
          attributes['tag_list'] << value
      end
    end
    attributes.reject{ |k,v| v.nil? }
  end

end