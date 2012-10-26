class Comment::Asset < ActiveRecord::Base
  belongs_to      :comment
  has_one         :ticket, :through => :comment
  mount_uploader  :file, FileUploader
  attr_accessible :file

  # TODO: find better way to do this
  def name
    file.path.split("/").last
  end
end