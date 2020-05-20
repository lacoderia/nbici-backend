class StreamingClassSerializer <  ActiveModel::Serializer

  attributes :id, :title, :description, :intensity, :length, :instructor, :active, :insertion_code, :photo 

  def instructor
    if object.instructor
      instructor_obj = {}
      instructor_obj[:id] = object.instructor.id
      instructor_obj[:first_name] = object.instructor.first_name
      instructor_obj[:last_name] = object.instructor.last_name
      return instructor_obj
    end
  end
end
