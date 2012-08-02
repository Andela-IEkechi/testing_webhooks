class CreateTicketStatuses < ActiveRecord::Migration
  def change
    create_table :ticket_statuses do |t|
      t.references :project, :null => false
      t.string :name
    end
  end
end
