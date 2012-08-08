class ProjectObserver < ActiveRecord::Observer
  observe :project

  cattr_accessor :disable_notifications # use this when doing migrations

  def after_update(record)
    return if ProjectObserver.disable_notifications
  end

end
