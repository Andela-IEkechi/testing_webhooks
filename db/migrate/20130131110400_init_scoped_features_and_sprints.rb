class InitScopedFeaturesAndSprints < ActiveRecord::Migration
  def up
    #--- feature
    add_column :projects, :features_sequence, :integer, :default => 0
    add_column :features, :scoped_id, :integer, :default => 0
    add_index :features, :project_id
    # add_index :features, [:project_id, :scoped_id]

    Feature.reset_column_information

    Project.find_each do |project|
      last_feature_id = (project.features.order('id ASC').last.id rescue 0)
      project.features_sequence = last_feature_id
      project.save!

      project.features.all.each_with_index do |feature,index|
        feature.scoped_id = index + 1
        feature.save!
      end
    end

    #--- sprint
    add_column :projects, :sprints_sequence, :integer, :default => 0
    add_column :sprints, :scoped_id, :integer, :default => 0
    add_index :sprints, :project_id
    # add_index :sprints, [:project_id, :scoped_id]

    Sprint.reset_column_information

    Project.find_each do |project|
      last_sprint_id = (project.sprints.order('id ASC').last.id rescue 0)
      project.sprints_sequence = last_sprint_id
      project.save!

      project.sprints.all.each_with_index do |sprint,index|
        sprint.scoped_id = index + 1
        sprint.save!
      end
    end
  end

  def down
    remove_column :features, :scoped_id
    remove_column :sprints, :scoped_id
    remove_column :projects, :features_sequence
    remove_column :projects, :sprints_sequence
    remove_index :features, :name => "index_features_on_project_id"
    # remove_index :features, :name => "index_features_on_project_id_and_scoped_id"
    remove_index :sprints, :name => "index_sprints_on_project_id"
    # remove_index :sprints, :name => "index_sprints_on_project_id_and_scoped_id"
  end
end
