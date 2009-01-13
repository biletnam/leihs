class Accessory < ActiveRecord::Base
  belongs_to :model
  has_and_belongs_to_many :inventory_pools

  # TODO - a manager can only create if the required accessory doesn't yet exist,
  # - update and delete are available only if no other inventory pool is also associated.
  # - modifying the model, if a related item is handed over, a warning has to be displayed  
  
  # - the admin defines the accessories for the given model
  # - when the admin assigns the first item of the given model to an inventory_pool,
  # then all accessories_inventory_pools assiociations are automatically generated 


  # TODO 13** implement quantity attribute

end
