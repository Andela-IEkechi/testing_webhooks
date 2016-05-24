class Attachment < ApplicationRecord
  belongs_to :comment
  
  attachment :file

  def filename
    file_filename
  end
end
