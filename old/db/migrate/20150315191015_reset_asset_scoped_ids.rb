class ResetAssetScopedIds < ActiveRecord::Migration
  def up
    Project.find_each do |project|
      p "#{project}..."
      p "... clearing out #{project.assets.where(:payload => nil).count} empty assets"
      project.assets.where(:payload => nil).each(&:delete)

      p "... resetting asset scoped id"
      project.assets.each_with_index do |asset, index|
        asset.scoped_id = index + 1
        asset.save
      end
      project.assets_sequence = project.assets.count
      project.save
    end
  end

  def down
  end
end


