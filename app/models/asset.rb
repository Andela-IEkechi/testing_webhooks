class Asset < ActiveRecord::Base
  include Scoped

  belongs_to      :project
  belongs_to      :sprint
  belongs_to      :feature
  belongs_to      :comment

  mount_uploader  :payload, FileUploader
  attr_accessible :payload

  #NOTE: DO NOT validate this, it prevents us from saving new assest on new comments (on new tickets implicitly)
  #validates :comment_id, :presence => true

  def name
    payload.file.filename rescue payload
  end

  def image?
    payload.file.content_type.include? 'image' rescue false
  end

end
