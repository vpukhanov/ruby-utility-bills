require 'csv'

# Data Access Object, gives an ability to read (and write) data
# from and to the data.csv file
module DAO
  DATA_PATH = File.expand_path('../data/data.csv', __dir__)

  def self.read_data
    if File.exist?(DATA_PATH)
      CSV.readlines(DATA_PATH, headers: true)
    else
      []
    end
  end

  def self.write_data(rows)
    CSV.open(DATA_PATH, 'w') do |csv|
      rows.each do |row|
        csv << row
      end
    end
  end
end
