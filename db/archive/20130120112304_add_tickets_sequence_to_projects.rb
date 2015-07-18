class AddTicketsSequenceToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :tickets_sequence, :integer, :default => 0
  end
end
