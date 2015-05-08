namespace "asset" do
  desc 'Check if the remote file for an asset still exists'
  task :file_check => :environment do
    Asset.find_each(&:verify_payload!)
  end
end
