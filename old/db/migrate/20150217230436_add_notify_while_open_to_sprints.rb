class AddNotifyWhileOpenToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :notify_while_open, :boolean, :default => false
  end
end
