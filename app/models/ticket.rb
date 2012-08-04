class Ticket < ActiveRecord::Base  
  after_save :create_comment
  belongs_to :ticketable, :polymorphic => true
  belongs_to :status, :class_name => 'TicketStatus'
  has_many   :comments, :order => :id

  attr_accessor :body, :status_id
  attr_accessible :title, :body, :status_id, :comments_attributes, :status
  accepts_nested_attributes_for :comments

  validates :title, :presence => true
  validates :ticketable_type, :presence => true
  validates :ticketable_id, :presence => true
  validates :status_id, :presence => true

  def to_s
    title
  end

  private
  def create_comment
    p 'XXXXXXXXXXXXXXXXXXXxx'
    p self.body
    p self.status
    self.comments.create(:body => self.body, :status => self.status)
    self.save!
  end
end
