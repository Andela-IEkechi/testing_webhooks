class BaseUploader < CarrierWave::Uploader::Base
  process :store_file_attributes

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    '/tmp/conductor-cache'
  end

  def remove_animation
    manipulate! do |img, index|
      index == 0 ? img : nil
    end
  end

  def image?(thing)
    (thing.content_type.include? 'image') rescue false
  end

  def local_name
    (model[mounted_as] || path).split('/').last
  rescue
    nil
  end

  def local_size
    model["#{mounted_as}_size".to_sym] || file.size
  rescue
    nil
  end

  def local_content_type
    model["#{mounted_as}_content_type".to_sym] || file.content_type
  rescue
    nil
  end

  private

  # NOTE: we use this te cache the file size and possibly other attrs.
  # It prevents unwanted trips to cloud storage which slows everything down
  def store_file_attributes
    if file && model
      model["#{mounted_as}_size".to_sym] = file.size
      model["#{mounted_as}_content_type".to_sym] = file.content_type
      #can add mime types and file names here, for example.
    end
  end


end
