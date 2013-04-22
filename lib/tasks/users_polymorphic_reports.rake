task :reportable_users => :environment do
  Report.all.each do |report|
    report.reportable_type = "User"
    report.reportable_id = report.user_id
    report.save validate: false
  end
end
