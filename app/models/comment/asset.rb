class Comment::Asset < ActiveRecord::Base
  belongs_to      :comment
  has_one         :ticket, :through => :comment
  mount_uploader  :payload, FileUploader
  attr_accessible :payload

  def name
    payload.file && payload.file.filename
  end
end