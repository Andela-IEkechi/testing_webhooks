# Judge.configure do
#   expose Status, :name
# end

Judge.config.exposed[Status] = [:name]
Judge.config.exposed[Board] = [:name]
