class DistributionSerializer < ActiveModel::Serializer

  attributes :id, :height, :width, :description, :inactive_seats, :active_seats, :total_seats

end
