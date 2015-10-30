# encoding: utf-8

class LogoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  def store_dir
    "storage/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :footer_thumb do
    process resize_to_limit: [40, nil]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
