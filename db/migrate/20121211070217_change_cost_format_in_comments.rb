class ChangeCostFormatInComments < ActiveRecord::Migration
  def self.up
   change_column :comments, :cost, :string
  end

  def self.down
   change_column :comments, :cost, :integer
  end
end
