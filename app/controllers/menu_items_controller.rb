class MenuItemsController < ApiController

  before_action :authenticate_user!, only: [:index]

  # GET /menu_items
  def index
    @menu_items = MenuItem.active_by_menu_type 

    render json: @menu_items
  end
  
end

