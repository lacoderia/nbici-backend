class StreamingClassesController < ApiController
  include ErrorSerializer

  before_action :authenticate_user!, only: :show

  def show
    begin
      @streaming_class = StreamingClass.find(params[:id])
      available_streaming_class = @streaming_class.validate_availability(current_user)
      render json: {streaming_class: @streaming_class.as_json(include: :instructor, except: [:created_at, :updated_at, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at]), available_streaming_class: available_streaming_class}
    rescue Exception => e
      @streaming_class = StreamingClass.new
      @streaming_class.errors.add(:error_showing_purchased_streaming_class, e.message)
      render json: ErrorSerializer.serialize(@streaming_class.errors), status: 500      
    end
  end

  def index
    @streaming_classes = StreamingClass.active
    render json: @streaming_classes    
  end

end
