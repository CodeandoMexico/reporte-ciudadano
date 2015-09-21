namespace :csv_to_yaml do
require 'csv'
require 'yaml'
  
  task :dependency => :environment do 
    data = CSV.read('lib/datasets/dependencias.csv', :headers => true).map(&:to_hash)
    File.open('lib/datasets/test.yml', 'w') { |f| f.write(data.to_yaml)}
  end

  task :cis => :environment do 
    data = CSV.read('lib/datasets/cis.csv', :headers => true).map(&:to_hash)
    File.open('lib/datasets/cis.yml', 'w') { |f| f.write(data.to_yaml)}
  end
  task :unidades => :environment do 
      data = CSV.read('lib/datasets/unidades.csv', :headers => true).map(&:to_hash)
      File.open('lib/datasets/unidades.yml', 'w') { |f| f.write(data.to_yaml)}
    end
end
