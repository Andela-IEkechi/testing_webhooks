class Document < ApplicationRecord
  belongs_to :documentable, polymorphic: true

  mount_uploader :file, FileUploader

  def image?
    file.local_content_type.include? 'image' rescue false
  end

  def to_s
    file.local_name
  end

  def file_size
    file.local_size
  end

end




