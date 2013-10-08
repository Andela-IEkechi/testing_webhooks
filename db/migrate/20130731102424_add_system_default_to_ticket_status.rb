class AddSystemDefaultToTicketStatus < ActiveRecord::Migration

	def up
		add_column :ticket_statuses, :system_default, :boolean, :default => false

		puts "Updating system_default for first two statuses"
		Project.find_each do |project|
			puts project
			project.ticket_statuses.unscoped.order('id asc').limit(2).each do |status|
				status.system_default = true
				status.save!
			end
		end
	end
	def down
		remove_column :ticket_statuses, :system_default
	end
end
