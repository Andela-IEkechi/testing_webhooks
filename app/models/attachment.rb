class Attachment < ApplicationRecord
  belongs_to :comment
  
  attachment :file
end
