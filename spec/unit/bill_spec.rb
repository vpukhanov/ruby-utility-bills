require 'bill'
require 'bill_types'

RSpec.describe Bill do
  before do
    @bill = Bill.new('total' => 500, 'paid' => 450, 'bill_type' => BillTypes::PHONE)
    @paid_bill = Bill.new('total' => 500, 'paid' => 500, 'bill_type' => BillTypes::PHONE)
  end

  context '#remaining' do
    it 'should return remaining ammount' do
      expect(@bill.remaining).to eq(@bill.total - @bill.paid)
    end

    it 'should return 0 if bill is paid or overpaid' do
      expect(@paid_bill.remaining).to eq(0)
      @paid_bill.add_ammount(50)
      expect(@paid_bill.remaining).to eq(0)
    end
  end

  context '#add_ammount' do
    it 'should increase paid ammount' do
      paid = @bill.paid
      @bill.add_ammount(10)
      expect(@bill.paid).to eq(paid + 10)
    end
  end

  context '#to_s' do
    it 'should contain type, paid ammount and total' do
      expect(@bill.to_s).to include(@bill.type.to_s)
      expect(@bill.to_s).to include(@bill.paid.to_s)
      expect(@bill.to_s).to include(@bill.total.to_s)
    end
  end
end
