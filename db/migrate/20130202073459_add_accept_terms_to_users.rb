class AddAcceptTermsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :terms, :boolean, default: false
    execute 'update users set terms=true;'
  end

  def down
    remove_column :users, :terms
  end
end
