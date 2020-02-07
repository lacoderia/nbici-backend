class MenuItemSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :price, :active, :menu_category_id

end
