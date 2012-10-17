class SetProjectOwnerParticipation < ActiveRecord::Migration
  def up
    Project.all.each do |project|
      Participant::set_owner_as_participant(project)
    end
  end

  def down
  end
end
