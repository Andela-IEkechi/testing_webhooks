class AddGithubEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github_email, :string, :default => nil, :after => :email
    # note: rails 3 doesn't seem to support :after.
  end
end
