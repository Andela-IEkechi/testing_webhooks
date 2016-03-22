class AddSystemDefaultToStatus < ActiveRecord::Migration

	def up
		add_column :statuses, :system_default, :boolean, :default => false

		puts "Updating system_default for first two statuses"
		Project.find_each do |project|
			puts project
			project.statuses.unscoped.order('id asc').limit(2).each do |status|
				status.system_default = true
				status.save!
			end
		end
	end
	def down
		remove_column :statuses, :system_default
	end
end
