class Backend::TemporaryController < Backend::BackendController
#  require_role "inventory_manager", :except => :create_some
  
  def create_some
    reset_session
    clean_db_and_index
    
    params[:id] = 3
    params[:name] = "model"
    if params[:all]
      max = params[:all].to_i
      if max > 0
        Importer.new.start(max)
      else
        Importer.new.start
      end
    else
      create_meaningful_inventory
    end
    
    create_some_packages
    create_some_templates
   # create_some_categories
    create_some_root_categories
    create_some_properties
    create_some_compatibles
    
    params[:id] = 5
    params[:name] = "admin"
    create_some_users
#TODO    
#    params[:name] = "student"
#    create_some_users

    create_meaningful_users

    params[:id] = 10
#    create_some_submitted_orders
#    create_beautiful_order

    render :text => "Complete"
  end
  
private
  
#  def create_some_inventory
#    params[:id].to_i.times do |i|
#      m = Model.new(:name => params[:name] + " " + i.to_s)
#      m.save
#      5.times do |serial_nr|
#        i = Item.new(:model_id => m.id, :inventory_code => Item.get_new_unique_inventory_code)
#      
#        i.save
#      end
#    end
#  end


  def create_some_users
    params[:id].to_i.times do |i|
      u = User.new(:login => "#{params[:name]}_#{i}")
        r = Role.find(:first, :conditions => {:name => "inventory_manager"})
        ips = InventoryPool.find(:all).select { rand(3) == 0 or i == 0 }
        ips.each do |ip|
          u.access_rights << AccessRight.new(:role => r, :inventory_pool => ip)
        end
      u.save
    end
  end

  def create_some_submitted_orders
    users = User.find(:all)
    models = Model.find(:all)
    params[:id].to_i.times do |i|
      order = Order.new
      order.user_id = users[rand(users.size)].id
      3.times {
        d = Array.new
        2.times { d << Date.new(rand(2)+2008, rand(12)+1, rand(28)+1) }
        start_date = d.min 
        end_date = d.max
        order.add_line(rand(3)+1, models[rand(models.size)], order.user_id, start_date, end_date )
      }
      order.purpose = "This is the purpose: text text and more text, text text and more text, text text and more text, text text and more text."
      order.submit
    end
  end
  
    
  def create_meaningful_users
    users = ['Ramon Cahenzli', 'Jerome Müller', 'Franco Sellitto']
    users.each do |u|
      u = User.new(:login => u.to_s)
      u.save
    end
  end
  
  def create_meaningful_inventory
    stuff = ['Beamer NEC LT 245', 'Beamer Davis 1650', 'Kamera Nikon D80', 'Stativ Manfrotto 390', 'Brillenputzuch', 'Laserschwert']

    stuff.each do |st|
      m = Model.new(:name => st )
      m.save
      2.times do |serial_nr|
        i = Item.new(:model_id => m.id, :inventory_code => Item.get_new_unique_inventory_code )
        i.save
      end
    end
  end


  def create_some_root_categories
    video = Category.create(:name => 'Video')
    audio = Category.create(:name => 'Audio')
    computer = Category.create(:name => 'Computer')
    light = Category.create(:name => 'Licht')
    foto = Category.create(:name => 'Foto')
    other = Category.create(:name => 'Anderes')
    stative = Category.create(:name => 'Stative')
    
    add_to(video, Category.find_or_create_by_name(:name => 'Video Kamera'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Film Kamera'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Video Kamera Zubehör'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Film Kamera Zubehör'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Video Monitor'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Video Recorder/Player'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Stativ Video/Film/Foto'))
    
    add_to(audio,  Category.find_or_create_by_name(:name => 'Audio Recorder portable'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Audio Recorder/Player'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Kopfhörer'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Lautsprecher/-anlagen'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Mikrofon'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Mikrofon Zubehör'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Verschiedene AV Geräte'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Verstärker'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Mikrofon Zubehör'))

    add_to(foto,  Category.find_or_create_by_name(:name => 'Dia-/Hellraumprojektor'))
    add_to(foto,  Category.find_or_create_by_name(:name => 'Foto analog'))
    add_to(foto,  Category.find_or_create_by_name(:name => 'Foto digital'))
    add_to(foto,  Category.find_or_create_by_name(:name => 'Foto Zubehör'))
    add_to(foto,  Category.find_or_create_by_name(:name => 'Stativ Video/Film/Foto'))
    
    add_to(light,  Category.find_or_create_by_name(:name => 'Licht/Scheinwerfer'))
    add_to(light,  Category.find_or_create_by_name(:name => 'Licht Stative'))
    add_to(light,  Category.find_or_create_by_name(:name => 'Licht Zubehör'))
    add_to(light,  Category.find_or_create_by_name(:name => 'Elektro Material'))

    add_to(computer,  Category.find_or_create_by_name(:name => 'Desktop Macintosh'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Desktop PC'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Externer Massenspeicher'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'IT-Display'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'IT-Zubehör'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Notebook'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'PowerBook'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Scanner/Lesegerät'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Server'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Netzwerkkomponente'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Andere Hardware'))

    add_to(other, Category.find_or_create_by_name(:name => 'DVD - Recorder/Player'))
    add_to(other, Category.find_or_create_by_name(:name => 'Medien-Rack/-Wagen'))
    add_to(other, Category.find_or_create_by_name(:name => 'Andere Hardware'))
    add_to(other, Category.find_or_create_by_name(:name => 'Leinwand'))
    add_to(other, Category.find_or_create_by_name(:name => 'Set-/Bühnenbau'))
    
    add_to(stative, Category.find_or_create_by_name(:name => 'Licht Stative'))
    add_to(stative, Category.find_or_create_by_name(:name => 'Stativ Video/Film/Foto'))
    
  end

  def add_to(parent, sub)
    parent.children << sub unless parent.children.include?(sub)
    sub.set_label(parent, sub.name)
  end

  def create_some_categories
    20.times do
      chars = ("A".."Z").to_a
      name = ""
      1.upto(5) { |i| name << chars[rand(chars.size-1)] } 
      Category.create(:name => name)
    end
    categories = Category.find(:all, :limit => rand(5)+3, :order => "RAND()")
    categories.each do |c|
      begin
#        c.children << Category.find(:all, :limit => rand(5)+3, :order => "RAND()", :conditions => ["id != ?", c.id])
        (rand(5)+3).times do |i|
          child = Category.find(:first, :order => "RAND()", :conditions => ["id != ?", c.id])
          c.children << child
          child.set_label(c, "#{child.name}_#{i}")
        end
        (rand(1)+1).times do |i|
          child = Package.find(:first, :order => "RAND()")
          c.children << child
          child.set_label(c, "#{child.name}_#{i}")

          child = Template.find(:first, :order => "RAND()")
          c.children << child
          child.set_label(c, "#{child.name}_#{i}")
        end
      rescue
      end
    
      m = Model.find(:first, :order => "RAND()")
      c.model_links << ModelLink.create(:model => m, :quantity => 1)
    end
  end

  def create_some_packages
    5.times do |i|
      ip = InventoryPool.find(:first, :order => "RAND()")
      p = Package.create(:name => "package_" + i.to_s, :inventory_pool => ip)

      (rand(5)+2).times do
        m = ip.models.find(:first, :order => "RAND()")
        p.model_links << ModelLink.create(:model => m, :quantity => rand(3)+1)
      end
    end
  end

  def create_some_templates
    5.times do |i|
      p = Template.create(:name => "template_" + i.to_s)

      (rand(5)+2).times do
        m = Model.find(:first, :order => "RAND()")
        p.model_links << ModelLink.create(:model => m, :quantity => rand(3)+1)
      end
    end
  end
  
  def create_some_properties
      chars_up = ("A".."Z").to_a
      chars_down = ("a".."z").to_a
      
      Model.all.each do |m|
        (rand(5)+1).times do
          key = ""
          value = ""
          1.upto(5) { |i| key << chars_up[rand(chars_up.size-1)] } 
          1.upto(5) { |i| value << chars_down[rand(chars_down.size-1)] } 
          m.properties << Property.create(:key => key, :value => value)
        end
      end
  end

  def create_some_compatibles
    Model.all.each do |m|
      begin
        m.compatibles << Model.find(:all, :limit => rand(5)+2, :order => "RAND()")
      rescue
      end
    end
  end
  
  def create_beautiful_order
    m = Model.find(:first)
  
    
    order = Order.new()
    order.user_id = User.find_by_login("Ramon Cahenzli")
    order.add_line(3, m, order.user_id, Date.new(2008, 10, 12), Date.new(2008, 10, 20))
    order.purpose = "This is the purpose: text text and more text, text text and more text, text text and more text, text text and more text."
    order.submit
    
    order = Order.new()
    order.user_id = User.find_by_login("Ramon Cahenzli")
    order.add_line(6, m, order.user_id, Date.new(2008, 10, 15), Date.new(2008, 10, 30))
    order.purpose = "This is the purpose: text text and more text, text text and more text, text text and more text, text text and more text."
    order.submit
    
    
    order = Order.new()
    order.user_id = User.find_by_login("Ramon Cahenzli")
    order.add_line(1, m, order.user_id, Date.new(2008, 10, 20), Date.new(2008, 10, 30))
    order.purpose = "This is the purpose: text text and more text, text text and more text, text text and more text, text text and more text."
    order.submit
    
  end
    
  def clean_db_and_index
    Item.delete_all
    Model.delete_all
    Order.delete_all #destroy_all
    OrderLine.delete_all
    User.delete_all
    Backup::Order.delete_all #destroy_all
    Backup::OrderLine.delete_all
    Contract.delete_all
    ContractLine.delete_all
    Printout.destroy_all
    AccessRight.delete_all
    ModelGroup.destroy_all
    
    FileUtils.remove_dir(File.dirname(__FILE__) + "/../../../index", true)
  end

end
