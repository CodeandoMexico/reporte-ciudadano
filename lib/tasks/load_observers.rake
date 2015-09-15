#rake load_observers:news
namespace :load_observers do
  
  task :news => :environment do 
    Admin.where(is_observer: true).delete_all
    admin = Admin.create(name: "Observer juan", email: 'observer@observer.com', password: "password", password_confirmation: "password", is_observer: true)
  end
end
