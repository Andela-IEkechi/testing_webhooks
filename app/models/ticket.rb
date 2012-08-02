class Ticket < ActiveRecord::Base
  belongs_to :ticketable, :polymorphic => true

  attr_accessible :title, :body

  validates :title, :presence => true

  def to_s
    title
  end
end
