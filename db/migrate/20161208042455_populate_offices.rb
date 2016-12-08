class PopulateOffices < ActiveRecord::Migration
  def change
    Office.delete_all
    Services.load_values(:cis).each do |cis|
      office = Office.new(cis)
      office.id = cis[:id]
      office.save!
    end
  end
end
