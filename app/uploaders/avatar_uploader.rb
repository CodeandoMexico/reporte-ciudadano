# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
   include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
   def default_url
     Gravatar.new("example@example.com").image_url
   end

   version :thumb do
     process resize_to_fill: [53, 53]
   end
end
