class AddAssigneeToComments < ActiveRecord::Migration[5.0]
  def change
    add_column 'comments', 'assignee_id', :integer, null: true
  end
end
