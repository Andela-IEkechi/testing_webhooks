class Attachment < ApplicationRecord
  belongs_to :comment
  has_one :ticket, through: :comment
   
  
  attachment :file

  def filename
    File.basename(file.read)
  end
end
