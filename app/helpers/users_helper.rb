module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, size=24, css_class=nil)
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: current_user, class: "gravatar #{css_class}")
  end

  def hide_comments?
    current_user.preferences.collapse_long_tickets == '1'
  end

  def can_delete_account?
    #if we have projects which have members, then we cant delete our account
    current_user.projects.select{|p| p.memberships.count > 1}.compact.none?
  end
end
