desc 'Generate slugs for existing projects'
task :generate_project_slugs => :environment do
  Project.find_each(&:save)
end