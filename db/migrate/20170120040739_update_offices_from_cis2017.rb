class UpdateOfficesFromCis2017 < ActiveRecord::Migration
  def change
    Rake::Task['organisations:migrate'].invoke
  end
end
