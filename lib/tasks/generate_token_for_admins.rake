task :generate_token_for_admins => :environment do
  Admin.all.each do |admin|
    token_generator = UniqueTokenGenerator.new(Admin, :authentication_token)
    admin.update_attribute(:authentication_token, token_generator.generate_token)
  end
end
