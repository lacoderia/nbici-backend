class AvailableStreamingClassesController < ApiController
  include ErrorSerializer

  before_action :authenticate_user!  

  def show
    begin
      @available_streaming_class = AvailableStreamingClass.find(params[:id])

      if @available_streaming_class.user != current_user
        raise "La clase no está disponible para este usuario."
      elsif (@available_streaming_class.start + 24.hours) < Time.zone.now
        raise "La clase ya cumplió su periodo de 24 horas de disponibilidad desde que la compraste."
      end

      render json: {available_streaming_class: @available_streaming_class.as_json(include: {streaming_class: {except: [:created_at, :updated_at, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at]}})}
    rescue Exception => e
      @available_streaming_class = AvailableStreamingClass.new
      @available_streaming_class.errors.add(:error_showing_purchased_stream_class, e.message)
      render json: ErrorSerializer.serialize(@available_streaming_class.errors), status: 500      
    end
  end

  def index
    @available_streaming_classes = current_user.available_streaming_classes.playable
    render json: @available_streaming_classes
  end

  # POST - streaming_class_id in body
  def purchase 
    begin
      @available_streaming_class = AvailableStreamingClass.purchase(params[:streaming_class_id], current_user)
      # TODO: stream_purchase email
      #SendEmailJob.perform_later("stream_purchase", current_user, @available_streaming_class)
      render json: @available_streaming_class
    rescue Exception => e
      @available_streaming_class = AvailableStreamingClass.new
      @available_streaming_class.errors.add(:error_purchasing_stream_class, e.message)
      render json: ErrorSerializer.serialize(@available_streaming_class.errors), status: 500 
    end
  end
  
end
