desc 'Generate slugs for existing tickets'
task :generate_ticket_slugs => :environment do
  Ticket.find_each(&:save)
end