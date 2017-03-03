require 'csv'
namespace :geo_names do
  desc 'import geo_names from csv'
  task import_data: :environment do
    CSV.foreach(Rails.root.join('db','geo_names','geo_geonames.csv'), headers: true) do |row|
      geo_name_hash = row.to_hash
      GeoName.create(geo_name_hash)
    end
    puts GeoName.count
    CSV.foreach(Rails.root.join('db','geo_names','geo_alternatenames.csv'), headers: true) do |row|
      geo_altername_hash = row.to_hash
      GeoAlternateName.create(geo_altername_hash)
    end
    puts GeoAlternateName.count
  end
end