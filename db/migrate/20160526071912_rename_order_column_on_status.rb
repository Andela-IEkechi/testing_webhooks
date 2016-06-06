class RenameOrderColumnOnStatus < ActiveRecord::Migration[5.0]
  def change
    rename_column :statuses, :order, :position
  end
end
