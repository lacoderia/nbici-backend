class StreamingClassesController < ApiController

  def index
    @streaming_classes = StreamingClass.active
    render json: @streaming_classes    
  end

end
