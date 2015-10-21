class Comment < ActiveRecord::Base
  include Markdownable
  acts_as_taggable

  after_create :update_ticket
  after_destroy :revert_ticket

  belongs_to :ticket #always
  belongs_to :user #the person who made the comment
  belongs_to :api_key, :foreign_key => 'api_key_name', :class_name => 'ApiKey'
  has_one    :project, :through => :ticket
  has_many   :assets, :dependent => :destroy

  belongs_to :sprint
  belongs_to :assignee, :class_name => 'User' # the user the ticket is assigned to
  belongs_to :status, :class_name => 'TicketStatus'

  accepts_nested_attributes_for :assets

  attr_accessible :body, :cost, :rendered_body, :commenter, :git_commit_uuid, :created_at
  attr_accessible :ticket_id, :user_id, :status_id, :sprint_id, :assignee_id, :assets_attributes, :api_key_name, :asset_ids
  attr_accessible :tag_list
  attr_accessor :foo

  #we can't enforce this in the model, or nested create fails : validates :ticket_id, :presence => true
  validates :cost, :inclusion => {:in => Ticket::COST}
  validates :api_key_name, :presence => true, :unless => lambda{|record| record.user_id }
  validates :user_id, :presence => true, :unless => lambda{|record| record.api_key_name }
  validates :status_id, :presence => true

  sifter :search do |string|
    cost.eq(string.to_i)
  end

  def to_s
    body
  end

  def parent
    sprint || project
  end

  def previous
    return ticket.comments.last if self.new_record?
    ticket.comments.select{|c| c.id < self.id}.last
  end

  def html
    rendered_body || ''
  end

  def only?
    ticket.comments.size == 1
  end

  def first?
    ticket.comments.first.id == self.id
  end

  private

  def update_ticket
    self.ticket.update_last_comment! if self.ticket
  end

  def revert_ticket
    self.ticket.update_last_comment! if self.ticket
  end

  def open?
    status.open?
  end
end
