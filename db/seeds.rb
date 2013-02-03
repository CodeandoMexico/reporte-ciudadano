admin = Admin.new(email: "admin@admin.com", password: "oaxacker", password_confirmation: "oaxacker")
admin.save

category = Category.create(name: 'Fuga')
["como", "donde", "cuando"].each do |category_field|
  category.category_fields.create(name: category_field)
end

Category.create(name: "Robo")