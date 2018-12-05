require 'payer'
require 'bill'
require 'bill_types'

RSpec.describe Payer do
  before do
    @payer = Payer.new('last_name' => 'Doe', 'first_name' => 'John', 'patronymic' => 'Wallace')
    @bill = Bill.new('total' => 500, 'paid' => 250, 'bill_type' => BillTypes::RENT)
    @paid_bill = Bill.new('total' => 500, 'paid' => 500, 'bill_type' => BillTypes::PHONE)

    @payer.add_bill(@bill)
  end

  context '#add_bill' do
    it 'should attach bill to payer' do
      expect(@payer.bills).to eq([@bill])
    end
  end

  context '#delete_bill' do
    it 'should detach bill from payer' do
      @payer.delete_bill(@bill)
      expect(@payer.bills).to eq([])
    end
  end

  context '#total_debt' do
    it 'should calculate total debt' do
      expect(@payer.total_debt).to eq(500)
      @payer.add_bill(@paid_bill)
      expect(@payer.total_debt).to eq(1000)
    end
  end

  context '#remaining_debt' do
    it 'should calculate remaining debt' do
      expect(@payer.remaining_debt).to eq(250)
      @payer.add_bill(@paid_bill)
      expect(@payer.remaining_debt).to eq(250)
    end
  end

  context '#unpaid_bills' do
    it 'should only return unpaid bills' do
      @payer.add_bill(@paid_bill)
      expect(@payer.unpaid_bills).to eq([@bill])
    end
  end

  context '#to_s' do
    before do
      @no_patronymic = Payer.new('last_name' => 'Doe', 'first_name' => 'John')
    end

    it 'should include last name and first name' do
      expect(@no_patronymic.to_s).to include(@no_patronymic.last_name)
      expect(@no_patronymic.to_s).to include(@no_patronymic.first_name)
    end

    it 'should include patronymic if payer has one' do
      expect(@payer.to_s).to include(@payer.last_name)
      expect(@payer.to_s).to include(@payer.first_name)
      expect(@payer.to_s).to include(@payer.patronymic)
    end

    it 'should not end with space if payer has no patronymic' do
      expect(@no_patronymic.to_s).to match(/\S$/)
    end
  end
end
