class DistributionsController < ApplicationController

  def by_room_id
    @distribution = Distribution.by_room_id(params[:room_id])
    render json: @distribution
  end  

end
