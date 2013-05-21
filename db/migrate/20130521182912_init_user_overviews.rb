class InitUserOverviews < ActiveRecord::Migration
  def up
    User.find_each do |user|
      user.overviews.create(:title => 'My Tickets', :filter => "assignee:#{user.email}")
    end
  end

  def down
    Overview.find_each(&:destroy)
  end
end
