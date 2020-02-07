class MenuCategoriesController < ApiController

  before_action :authenticate_user!, only: [:index]

  # GET /menu_items
  def index
    @menu_categories = MenuCategory.all

    render json: @menu_categories
  end
  
end

