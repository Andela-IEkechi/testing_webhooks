# Judge.configure do
#   expose TicketStatus, :name
# end

Judge.config.exposed[TicketStatus] = [:name]
