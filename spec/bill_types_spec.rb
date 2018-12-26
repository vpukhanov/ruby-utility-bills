require 'bill_types'

RSpec.describe BillTypes do
  context '::from_string' do
    it 'should convert strings to constants' do
      original = %w[phone electricity rent]
      expected = [BillTypes::PHONE, BillTypes::ELECTRICITY, BillTypes::RENT]

      converted = original.map { |str| BillTypes.from_string(str) }

      expect(converted).to eq(expected)
    end

    it 'should be case-insensitive' do
      expect(BillTypes.from_string('ELeCTRiCiTy')).to eq(BillTypes::ELECTRICITY)
    end

    it 'should raise an error for unknown type' do
      expect { BillTypes.from_string('undefined') }.to raise_error(RuntimeError)
    end
  end
end
