class AvailableStreamingClassSerializer <  ActiveModel::Serializer

  attributes :id, :start, :user, :streaming_class

  def user
    object.user
  end

  def streaming_class
    streaming_obj = {}
    streaming_obj[:id] = object.streaming_class.id
    streaming_obj[:title] = object.streaming_class.title
    streaming_obj[:description] = object.streaming_class.description
    streaming_obj[:intensity] = object.streaming_class.intensity
    streaming_obj[:instructor_id] = object.streaming_class.instructor_id
    streaming_obj[:active] = object.streaming_class.active
    streaming_obj[:photo] = object.streaming_class.photo
    streaming_obj 
  end

end

