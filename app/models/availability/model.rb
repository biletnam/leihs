module Availability
  module Model
    
    def availability_in(inventory_pool)
      # we keep the result in an instance variable to avoid recompute during the same request
      # NOTE this simple-cache doesn't seem to be influent, let's go normal
      #@av ||= {}
      #@av[inventory_pool.id] ||= 
      Availability::Main.new(:model => self, :inventory_pool => inventory_pool)
    end

    def total_borrowable_items_for_user(user, inventory_pool = nil)
      groups = user.groups
      if inventory_pool
        partitions.in(inventory_pool).by_groups(groups).sum(:quantity)
      else       
        inventory_pools.sum {|ip| partitions.in(ip).by_groups(groups).sum(:quantity) }
      end
    end

    def availability_periods_for_user(user, with_total_borrowable = false) #, start_date = Date.today, end_date = Availability::Change::ETERNITY)
      (inventory_pools & user.inventory_pools).collect do |inventory_pool|
        groups = user.groups.scoped_by_inventory_pool_id(inventory_pool)
        h = {:inventory_pool => inventory_pool.as_json, # FIXME extract this ?? this is used for the frontend only ??
             :availability => availability_in(inventory_pool).available_quantities_for_groups(groups + [Group::GENERAL_GROUP_ID]) }
        if with_total_borrowable
          h[:total_borrowable] = partitions.in(inventory_pool).by_groups(groups).sum(:quantity).to_i 
        end
        h
      end
    end
  end
end
