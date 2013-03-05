class ChangeFreeAccountsToTrialAccounts < ActiveRecord::Migration
  def up
    User.find_each do |user|
      if user.account && user.account.plan == "free"
        user.account.update_attributes(:plan => "trial")
      end
    end
  end

  def down
    User.find_each do |user|
      if user.account && user.account.plan == "trial"
        user.account.update_attributes(:plan => "free")
      end
    end
  end
end
