class Purchase < ActiveRecord::Base
  belongs_to :pack
  belongs_to :user
end
