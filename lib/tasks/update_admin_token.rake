task :ensure_api_admin_token => :environment do 
  Admin.all.each do |admin|
    admin.ensure_authentication_token
    admin.save
  end
end
