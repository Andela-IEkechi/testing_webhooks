class AccessesController < ApplicationController
  load_and_authorize_resource :project

  def edit
    #get all the users accross all the projects to select from
    @memberships = current_user.projects.collect(&:memberships).flatten.uniq.sort{|a,b| a.user_email <=> b.user_email}
  end

  def update
    #create new users based on membership attributes
    #the project owner has to be a member
    params[:project][:memberships_attributes].each do |token, membership_attr|

      if membership_attr[:id]
        membership = Membership.find(membership_attr[:id])
        if membership_attr[:role] && membership_attr[:role].empty?
          # find all project tickets where this membership user is an assignee
          user_assinged_tickets =  @project.tickets.
            joins(:comments).
            where(['comments.id = tickets.last_comment_id and comments.assignee_id=?', membership.user_id]).
            includes(:last_comment => :status) 
           user_assinged_tickets.each do |ticket|
              # just another measure, dont worry, last_comment is already loaded(performance :-))
              if membership.user_id == ticket.last_comment.assignee_id && ticket.last_comment.status.open?
                    #create a new comment, but dont tell the ticket about it, or it will render
                    comment = Comment.new( :ticket_id   => ticket.to_param,
                                           :status_id   => ticket.status.to_param,
                                           :feature_id  => ticket.feature_id, #use the real id here!
                                           :sprint_id   => ticket.sprint_id, #use the real id here!
                                           :assignee_id => nil, # no more assigned user
                                           :body        => "#{membership.user} removed from project",
                                           :cost        => ticket.cost)
                    comment.user = current_user
                    
                   comment.save! # let it fail if there is something wrong 
              end  
          end
          
          membership.destroy  #clean house if the member is removed
        else
          user = membership.user
        end
      else
        user_attr = membership_attr[:user]
        user = User.find_by_email(user_attr[:email].downcase)
        user ||= User.invite!(:email => user_attr[:email].downcase) unless user_attr[:email].blank?
      end

      if user && (membership = @project.memberships.find_or_create_by_user_id(:user_id => user.id))
        membership.role = membership_attr[:role] if membership
        membership.save
      end
    end

    flash[:notice] = "Project access updated"
    redirect_to edit_project_path(@project, :current_tab => 'access-control')
  end
end

