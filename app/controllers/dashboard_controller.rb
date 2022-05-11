class DashboardController < ApplicationController

  def index
    uploads = Upload.where(user_id: current_user.id).order('id DESC')
    @json_string = UploadSerializer.new(uploads).serialized_json
  end
  
end
