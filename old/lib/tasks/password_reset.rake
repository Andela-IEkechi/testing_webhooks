def reset_passwords
    puts "Resetting all confirmed users passwords to '@1secret' "
    User.find_each do |u|
      if u.confirmed?
        u.password = '@1secret'
        u.save
        puts u
      end
    end
end

namespace :db do
  desc "Resets all confirmed users passwords to 'secret' "
  task :reset_passwords => :environment do
    reset_passwords
  end
end
