module Scoped
  extend ActiveSupport::Concern

  included do
    before_create :populate_scoped_id

    def to_param
      self.scoped_id
    end

    private
    def populate_scoped_id
      sequence = "#{self.class.name.downcase.pluralize}_sequence".to_sym #eg. tickets_sequence or sprints_sequence etc
      self.project.with_lock do #lock and reload forces us to correctly increment the id
        self.project.reload
        self.project.increment!(sequence)
        self.scoped_id = self.project.send(sequence)
      end
      self.scoped_id
    end

  end
end

