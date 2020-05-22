class AvailableStreamingClassesController < ApiController
  include ErrorSerializer

  before_action :authenticate_user!  

  def index
    @available_streaming_classes = current_user.available_streaming_classes.playable
    render json: @available_streaming_classes
  end

  # POST - streaming_class_id in body
  def purchase 
    begin
      @available_streaming_class = AvailableStreamingClass.purchase(params[:streaming_class_id], current_user)
      SendEmailJob.perform_later("streaming_booking", current_user, @available_streaming_class)
      render json: @available_streaming_class
    rescue Exception => e
      @available_streaming_class = AvailableStreamingClass.new
      @available_streaming_class.errors.add(:error_purchasing_stream_class, e.message)
      render json: ErrorSerializer.serialize(@available_streaming_class.errors), status: 500 
    end
  end
  
end
