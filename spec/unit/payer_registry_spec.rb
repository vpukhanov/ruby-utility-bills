require 'payer_registry'
require 'payer'
require 'bill_types'
require 'dao'

RSpec.describe PayerRegistry do
  before do
    @registry = PayerRegistry.new

    @payer_one = Payer.new('last_name' => 'Ivanov', 'first_name' => 'Ivan', 'patronymic' => 'Ivanovich')
    @payer_two = Payer.new('last_name' => 'Doe', 'first_name' => 'John')

    @payer_hash = { 'last_name' => 'a', 'first_name' => 'b', 'patronymic' => 'c' }
    @bill_hash = { 'bill_type' => BillTypes::PHONE, 'total' => 500, 'paid' => 400 }

    @registry.add(@payer_one)
    @registry.add(@payer_two)
  end

  context '::create_from_file' do
    it 'should create registry from file' do
      row = @payer_hash.merge(@bill_hash)
      expect(DAO).to receive(:read_data).and_return([row])

      registry = PayerRegistry.create_from_file
      payer = registry.all[0]
      expect(payer).to be_a(Payer)
      expect(payer.total_debt).to eq(@bill_hash['total'])
    end
  end

  context '#all' do
    it 'should return all payers' do
      expect(@registry.all).to eq([@payer_one, @payer_two])
    end
  end

  context '#in_debt_range' do
    it 'should return all payers with debt in range' do
      expect(@payer_one).to receive(:remaining_debt).and_return(500)
      expect(@payer_two).to receive(:remaining_debt).and_return(150)

      expect(@registry.in_debt_range(50, 150)).to eq([@payer_two])
    end

    it 'should include range limits' do
      expect(@payer_one).to receive(:remaining_debt).and_return(100)
      expect(@payer_two).to receive(:remaining_debt).and_return(200)

      expect(@registry.in_debt_range(100, 200)).to eq([@payer_one, @payer_two])
    end
  end

  context '#create_bill' do
    it 'should create a payer if there is no payer with such name' do
      len = @registry.all.length
      @registry.create_bill(@payer_hash, @bill_hash)
      expect(@registry.all.length).to eq(len + 1)
    end

    it 'should call add_bill on payer' do
      payer_double = instance_double('Payer')

      expect(@registry).to receive(:by_payer_hash).and_return(payer_double)
      expect(payer_double).to receive(:add_bill)

      @registry.create_bill(@payer_hash, @bill_hash)
    end
  end

  context '#to_rows' do
    it 'should create a title row' do
      expect(@registry.to_rows[0]).to eq(%w[last_name first_name patronymic bill_type total paid])
    end

    it 'should include all bills' do
      @registry.create_bill(@payer_hash, @bill_hash)
      @registry.create_bill(@payer_hash, @bill_hash)
      expect(@registry.to_rows.length).to eq(2 + 1)
    end
  end

  context '#add' do
    it 'should add payer to collection' do
      payer = instance_double('Payer')
      @registry.add(payer)
      expect(@registry.all).to include(payer)
    end
  end

  context '#by_full_name' do
    it 'should return payer with specified full name' do
      payer = @registry.by_full_name('Ivanov Ivan Ivanovich')
      expect(payer).to eq(@payer_one)
    end

    it 'should return nil if there is no payer with specified name' do
      payer = @registry.by_full_name('Z Z Z')
      expect(payer).to be_nil
    end
  end

  context '#create_payer' do
    it 'should create payer from specified payer hash' do
      payer = @registry.create_payer(@payer_hash)
      expect(payer).to be_a(Payer)
      expect(@registry.all).to include(payer)
    end

    it 'should return false payer with specified hash is already in registry' do
      @registry.create_payer(@payer_hash)
      payer_two = @registry.create_payer(@payer_hash)
      expect(payer_two).to be(false)
    end
  end
end