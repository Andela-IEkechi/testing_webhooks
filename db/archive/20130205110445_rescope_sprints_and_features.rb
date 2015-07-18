class RescopeSprintsAndFeatures < ActiveRecord::Migration
  def up
    Project.find_each do |project|
      project.features_sequence = (project.features.count rescue 0)
      project.save!

      project.features.order('id ASC').each_with_index do |feature,index|
        feature.scoped_id = index + 1
        feature.save!
      end

      project.sprints_sequence = (project.sprints.count rescue 0)
      project.save!

      project.sprints.order('id ASC').each_with_index do |sprint,index|
        sprint.scoped_id = index + 1
        sprint.save!
      end
    end
  end

  def down
  end
end
