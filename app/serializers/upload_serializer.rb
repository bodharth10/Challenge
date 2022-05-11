class UploadSerializer < ApplicationSerializer
  attributes :title, :description

  attribute :attachment do |upload|
    Rails.application.routes.url_helpers.rails_blob_path(upload.file, only_path: true)
  end

  attribute :filename do |upload|
    upload.file.filename
  end

  attribute :file_type do |upload|
    upload.file.content_type
  end

  attribute :file_size do |upload|
    upload.file.byte_size
  end

  attribute :tiny_url do |upload|
    if Rails.env.development?
      base_url = 'localhost:3000'
    elsif Rails.env.production?
      base_url = Rails.application.credentials[:production][:host]
    end
    Rails.application.routes.url_helpers.rails_blob_url(upload.file, host: base_url)
  end

end