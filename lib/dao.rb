require 'csv'

# Data Access Object, gives an ability to read (and write) data
# from and to the data.csv file
module DAO
  def self.data_path
    if ENV['RACK_ENV'] == 'test'
      File.expand_path('../spec/test_data.csv', __dir__)
    else
      File.expand_path('../data/data.csv', __dir__)
    end
  end

  def self.read_data
    if File.exist?(data_path)
      CSV.readlines(data_path, headers: true)
    else
      []
    end
  end

  def self.write_data(rows)
    CSV.open(data_path, 'w') do |csv|
      rows.each do |row|
        csv << row
      end
    end
  end
end
