class AddStatesToExistingProjects < ActiveRecord::Migration
  def change
    close_states = ['closed','invalid','resolved']
    TicketStatus.find_each do |ts|
      ts.close! if close_states.include? ts.name
    end
  end
end
