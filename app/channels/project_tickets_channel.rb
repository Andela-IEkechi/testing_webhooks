# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ProjectTicketsChannel < ApplicationCable::Channel
  def subscribed
    # try and stream from all available boards
    self.available_project_ids.each do |project_id|
      stream_from "project:#{project_id}:tickets"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  protected

  def available_project_ids
    current_user.projects.pluck(:id)
  end

end
