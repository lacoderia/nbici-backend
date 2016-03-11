class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :classes_left, :last_class_purchased, :picture, :uid
end
