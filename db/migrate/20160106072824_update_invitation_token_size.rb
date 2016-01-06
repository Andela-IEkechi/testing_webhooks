class UpdateInvitationTokenSize < ActiveRecord::Migration
  def up
    change_column :users, :invitation_token, :string, :length => 255
  end

  def down
    change_column :users, :invitation_token, :string, :length => 60
  end
end
