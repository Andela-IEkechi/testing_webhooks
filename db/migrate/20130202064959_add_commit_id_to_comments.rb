class AddCommitIdToComments < ActiveRecord::Migration
  def change
    add_column 'comments', 'git_commit_uuid', :string
    add_index :comments, :git_commit_uuid
  end
end
