class Comment::Asset < ActiveRecord::Base
  belongs_to      :comment
  has_one         :ticket, :through => :comment
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