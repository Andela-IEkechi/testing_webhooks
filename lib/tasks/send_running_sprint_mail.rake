desc 'Sends mail to all members of a running sprint. A running sprint is any sprint with a due date within one week from the current date, which has open tickets'
task :send_running_sprint_mail => :environment do
  # puts "hello"

  sprints = Sprint.all

  sprints.each do |e|
    puts ">>> #{e.open?}"

    if e.open?
      #send mail to all participants
      
    end
  end
end