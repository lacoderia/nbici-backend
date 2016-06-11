class CreditModification < ActiveRecord::Base
  belongs_to :user
  belongs_to :pack
end
