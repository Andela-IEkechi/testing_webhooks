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
      self.project.increment!(sequence)
      self.scoped_id = project.send(sequence)
    end

  end
end

