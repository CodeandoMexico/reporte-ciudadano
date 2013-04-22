task :reportable_users => :environment do
  Report.all.each do |report|
    report.update_attribute :reportable_type, "User"
    report.update_attribute :reportable_id, report.user_id
  end
end
