class InstructorSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :picture, :quote, :bio
end
