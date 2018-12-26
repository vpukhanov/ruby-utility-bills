require 'dao'
require 'csv'

RSpec.describe DAO do
  context '::read_data' do
    it 'should read csv including headers' do
      expect(File).to receive(:exist?).and_return(true)
      expect(CSV).to receive(:readlines).with(kind_of(String), hash_including(headers: true))
      DAO.read_data
    end

    it 'should return empty array if file does not exist' do
      expect(File).to receive(:exist?).and_return(false)
      expect(DAO.read_data).to eq([])
    end
  end

  context '::write_data' do
    it 'should write all rows to file' do
      data = []

      expect(CSV).to receive(:open).and_yield(data)
      DAO.write_data([1, 2, 3])

      expect(data).to eq([1, 2, 3])
    end
  end
end
