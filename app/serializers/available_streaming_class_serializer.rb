class AvailableStreamingClassSerializer <  ActiveModel::Serializer

  attributes :id, :start, :user, :streaming_class

  def user
    object.user
  end

  def streaming_class
    object.streaming_class
  end

end

