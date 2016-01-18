class FixDuplicateScopedIds < ActiveRecord::Migration
  def up
    # find all the assets that have duplicate asset IDs (per project)
    Project.find_each do |project|
      p "processing #{project.to_s} ..."
      project.sprints.each do |sprint|
        #check if there is another asset with the same scoped ID
        if project.sprints.where(:scoped_id => sprint.scoped_id).count > 1
          #change our scoped_id
          old_scoped_id = asset.scoped_id
          sprint.send(:populate_scoped_id)
          # sprint.save(:validate => false)
          p "#{old_scoped_id} -> #{sprint.scoped_id} for #{sprint.to_s} "
        end
      end
      project.assets.each do |asset|
        #check if there is another asset with the same scoped ID
        if project.assets.where(:scoped_id => asset.scoped_id).count > 1
          #change our scoped_id
          old_scoped_id = asset.scoped_id
          asset.send(:populate_scoped_id)
          asset.save(:validate => false)
          p "#{old_scoped_id} -> #{asset.scoped_id} for #{asset.to_s} "
        end
      end
    end
  end

  def down
  end
end
