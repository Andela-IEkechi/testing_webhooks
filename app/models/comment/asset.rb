class Comment::Asset < ActiveRecord::Base
  belongs_to      :comment
  has_one         :ticket, :through => :comment
  mount_uploader  :file, FileUploader
  attr_accessible :file
end