class Api::V1::UploadController < Api::ApiController
    before_action :set_upload, only: [:destroy]

    def create
      @upload = Upload.new(item_params.merge(user_id: current_user.id))
      if @upload.save
        attach_main_pic if upload_params[:file].present?
        render json: UploadSerializer.new(@upload).serialized_json, status: :created
      else
        render json: @upload.errors, status: :unprocessable_entity 
      end
    end

    def destroy
      if @upload
        @upload.destroy!
        head :no_content
      end
    end

    private

    def item_params
      {
        title: upload_params[:title],
        description: upload_params[:description],
      }
    end

    def upload_params
      params.permit(
        :title,
        :description,
        :file
      )
    end

    def attach_main_pic
      @upload.file.attach(upload_params[:file])
    end

    def set_upload
      @upload = Upload.where(user_id: current_user.id).find(params[:id])
    end
end  