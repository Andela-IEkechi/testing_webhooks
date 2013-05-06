class CreateAccountsForExistingUsers < ActiveRecord::Migration
  def up
    User.find_each do |user|
      unless user.account
        user.create_account(:plan => :free)
        user.terms = true
        user.save
      end
    end
  end

  def down
  end
end
