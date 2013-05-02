class CollectionPhotograph < ActiveRecord::Base
  belongs_to :collection
  belongs_to :photograph
end
