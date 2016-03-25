class FileUploader < BaseUploader
  version :thumb, :if => :image? do
    process :remove_animation
    process :convert => 'jpg'
    process :resize_to_fill => [100, 100]
  end
end
