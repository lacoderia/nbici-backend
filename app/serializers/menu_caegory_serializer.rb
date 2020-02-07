class MenuCategorySerializer < ActiveModel::Serializer

  attributes :id, :name, :image_url, :menu_items

  def menu_items
    object.menu_items.active
  end

end
