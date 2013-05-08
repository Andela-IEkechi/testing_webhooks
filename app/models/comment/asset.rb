class Comment::Asset < ActiveRecord::Base
  belongs_to      :comment, :dependent => :destroy
  has_one         :ticket, :through => :comment
  mount_uploader  :payload, FileUploader

  attr_accessible :payload

  def name
    payload.file.filename rescue payload
  end

  def image?
    payload.file.content_type.include? 'image' rescue false
  end

end