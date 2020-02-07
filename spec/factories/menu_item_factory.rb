FactoryGirl.define do

  factory :menu_item, class: MenuItem do
    association :menu_category, factory: :menu_category     
    name "menu item"
    description "menu ingredients"
    price 75.0
    active true
  end

end
