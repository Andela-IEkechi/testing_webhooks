class GenerateProjectSlugs < ActiveRecord::Migration
  def up
    Project.find_each  do |p|
      p.save
    end
  end

  def down
  end
end
