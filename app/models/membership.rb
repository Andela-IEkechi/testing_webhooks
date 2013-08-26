class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  ROLE_NAMES = %w(admin regular restricted)

  validates :role, :inclusion => {:in => ROLE_NAMES}
  validates :user_id, :presence => true
  validates :project_id, :presence => true

  scope :for_user, lambda{|user_id| {:conditions => {:user_id => user_id}}}
  scope :by_email, lambda{|email| {:conditions => ['LOWER(users.email) = LOWER(?)', email], :joins => :user}}
  scope :admins, where(:role => 'admin')

  attr_accessible :role, :user_id, :project_id

  delegate :email, :to => :user, :prefix => false, :allow_nil => true



  def admin?
    self.role == 'admin'
  end

  def regular?
    self.role == 'regular'
  end

  def restricted?
    self.role == 'restricted'
  end

  def admin!
    unless self.admin?
      self.role = 'admin'
      self.save
    end
  end

  def unassign_user_from_tickets!(current_user)

    # find all project tickets where this membership user is an assignee
    user_assinged_tickets =  project.tickets.
      joins(:comments).
      where(['comments.id = tickets.last_comment_id and comments.assignee_id=?', user_id]).
      includes(:last_comment => :status)
     user_assinged_tickets.each do |ticket|
        # just another measure, dont worry, last_comment is already loaded(performance :-))
        if user_id == ticket.last_comment.assignee_id && ticket.last_comment.status.open?
              #create a new comment, but dont tell the ticket about it, or it will render
              comment = Comment.new( :ticket_id   => ticket.to_param,
                                     :status_id   => ticket.status.to_param,
                                     :feature_id  => ticket.feature_id, #use the real id here!
                                     :sprint_id   => ticket.sprint_id, #use the real id here!
                                     :assignee_id => nil, # no more assigned user
                                     :body        => "#{user} removed from project",
                                     :cost        => ticket.cost)
              comment.user = current_user

             comment.save! # let it fail if there is something wrong
        end
    end
    return true
  end
end
