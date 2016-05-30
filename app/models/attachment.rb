class Attachment < ApplicationRecord
  belongs_to :comment
  
  attachment :file

  def filename
    file_filename || File.basename(file.read)
  end
end
