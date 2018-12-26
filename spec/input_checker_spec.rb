require 'input_checker'
require 'bill_types'

RSpec.describe InputChecker do
  before do
    @helpers = Object.new
    @helpers.extend(InputChecker)
  end

  context '#empty_or_blank?' do
    it 'should return true for empty string' do
      expect(@helpers.empty_or_blank?('')).to be(true)
    end

    it 'should return true for blank string' do
      expect(@helpers.empty_or_blank?('    ')).to be(true)
    end

    it 'should return false for non-empty non-blank string' do
      expect(@helpers.empty_or_blank?('test')).to be(false)
    end
  end

  context '#to_float' do
    it 'should return nil for not float strings' do
      expect(@helpers.to_float('abc')).to be_nil
      expect(@helpers.to_float('   ')).to be_nil
    end

    it 'should return float for float strings' do
      expect(@helpers.to_float('25.34')).to eq(25.34)
    end
  end

  context '#to_integer' do
    it 'should return nil for not integer strings' do
      expect(@helpers.to_integer('abc')).to be_nil
      expect(@helpers.to_integer('   ')).to be_nil
    end

    it 'should return integer for integer strings' do
      expect(@helpers.to_integer('-25')).to eq(-25)
    end
  end

  context '#to_bill_type' do
    it 'should return nil for not bill type strings' do
      expect(@helpers.to_bill_type('abc')).to be_nil
      expect(@helpers.to_bill_type('   ')).to be_nil
    end

    it 'should return bill type for bill type strings' do
      expect(@helpers.to_bill_type('phone')).to eq(BillTypes::PHONE)
      expect(@helpers.to_bill_type('electricity')).to eq(BillTypes::ELECTRICITY)
      expect(@helpers.to_bill_type('rent')).to eq(BillTypes::RENT)
    end
  end

  context '#validate_payer' do
    before do
      @payer = { 'last_name' => 'Doe', 'first_name' => 'John', 'patronymic' => 'Wallace' }
    end

    it 'should give an error if last_name is blank' do
      @payer['last_name'] = '       '
      expect(@helpers.validate_payer(@payer)).not_to be_empty
    end

    it 'should give an error if first_name is blank' do
      @payer['first_name'] = ''
      expect(@helpers.validate_payer(@payer)).not_to be_empty
    end

    it 'should NOT give an error if patronymic is blank' do
      @payer['patronymic'] = ''
      expect(@helpers.validate_payer(@payer)).to be_empty
    end

    it 'should not give an error if everything is okay' do
      expect(@helpers.validate_payer(@payer)).to be_empty
    end
  end

  context '#validate_bill' do
    before do
      @bill = { 'total' => 500, 'paid' => 450, 'bill_type' => 'phone' }
    end

    it 'should give an error if total is not a float' do
      @bill['total'] = 'abc'
      expect(@helpers.validate_bill(@bill)).not_to be_empty
    end

    it 'should give an error if total is negative' do
      @bill['total'] = -500
      expect(@helpers.validate_bill(@bill)).not_to be_empty
    end

    it 'should give an error if total is zero' do
      @bill['total'] = 0
      expect(@helpers.validate_bill(@bill)).not_to be_empty
    end

    it 'should give an error if paid is not a float' do
      @bill['paid'] = 'abc'
      expect(@helpers.validate_bill(@bill)).not_to be_empty
    end

    it 'should give an error if paid is negative' do
      @bill['paid'] = -500
      expect(@helpers.validate_bill(@bill)).not_to be_empty
    end

    it 'should give an error if paid is larger than total' do
      @bill['paid'] = 600
      expect(@helpers.validate_bill(@bill)).not_to be_empty
    end

    it 'should give an error if bill type is unknown' do
      @bill['bill_type'] = 'abc'
      expect(@helpers.validate_bill(@bill)).not_to be_empty
    end

    it 'should not give an error if everything is okay' do
      expect(@helpers.validate_bill(@bill)).to be_empty
    end
  end

  context '#validate_payment' do
    before do
      @payment = { 'to_pay' => 100 }
      @bill = instance_double('Bill')
      allow(@bill).to receive(:remaining).and_return(200)
    end

    it 'should give an error if ammount to pay is not a float' do
      @payment['to_pay'] = 'abc'
      expect(@helpers.validate_payment(@payment, @bill)).not_to be_empty
    end

    it 'should give an error if ammount to pay is not positive' do
      @payment['to_pay'] = -5
      expect(@helpers.validate_payment(@payment, @bill)).not_to be_empty

      @payment['to_pay'] = 0
      expect(@helpers.validate_payment(@payment, @bill)).not_to be_empty
    end

    it 'should give an error if ammount to pay is greater than remaining ammount' do
      @payment['to_pay'] = 500
      expect(@helpers.validate_payment(@payment, @bill)).not_to be_empty
    end

    it 'should not give an error if everything is okay' do
      expect(@helpers.validate_payment(@payment, @bill)).to be_empty
    end
  end

  context '#validate_range' do
    before do
      @range = { 'from' => 100, 'to' => 200 }
    end

    it 'should give an error if from is not a float' do
      @range['from'] = 'abc'
      expect(@helpers.validate_range(@range)).not_to be_empty
    end

    it 'should give an error if to is not a float' do
      @range['to'] = 'abc'
      expect(@helpers.validate_range(@range)).not_to be_empty
    end

    it 'should give an error if from is larger than to' do
      @range['from'] = 300
      expect(@helpers.validate_range(@range)).not_to be_empty
    end

    it 'should not give an error if everything is okay' do
      expect(@helpers.validate_range(@range)).to be_empty
    end
  end
end
