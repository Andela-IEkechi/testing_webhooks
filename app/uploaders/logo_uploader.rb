class LogoUploader < BaseUploader
  version :thumb, :if => :image? do
    process :remove_animation
    process :convert => 'jpg'
    process :resize_to_fit => [150, 75]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
