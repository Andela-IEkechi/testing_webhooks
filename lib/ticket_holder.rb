module TicketHolder
  extend ActiveSupport::Concern

  included do
    #has_many :tickets #tickets are tied to a project, so we dont destroy them if we
    has_many :comments
    has_many :tickets, :through => :comments

    before_destroy :orphan_comments!

    def orphan_tickets!
      self.comments.each do |comment|
        comment.feature = nil
        comment.sprint = nil
        comment.save!
      end
    end
  end

end
