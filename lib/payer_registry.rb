require_relative 'payer'
require_relative 'bill'

# Registry class that acts as a data store for Payers and
# holds logic for accessing/creating/filtering of Payer
# and Bill objects.
class PayerRegistry
  def initialize
    @collection = {}
  end

  def all
    @collection.values
  end

  def in_debt_range(low, high)
    @collection.values.select do |payer|
      debt = payer.remaining_debt
      debt >= low && debt <= high
    end
  end

  def create_bill(payer_hash, bill_hash)
    payer = by_payer_hash(payer_hash)
    payer.add_bill(Bill.new(bill_hash))
  end

  def to_rows
    rows = [
      %w[last_name first_name patronymic bill_type total paid]
    ]
    @collection.values.each do |payer|
      payer.bills.each do |bill|
        rows.append([
                      payer.last_name, payer.first_name, payer.patronymic,
                      bill.type, bill.total, bill.paid
                    ])
      end
    end
    rows
  end

  def add(payer)
    @collection[payer.to_s] = payer
  end

  private

  def by_payer_hash(payer_hash)
    full_name = Payer.calculate_full_name(payer_hash)
    add(Payer.new(payer_hash)) unless @collection.include?(full_name)
    @collection[full_name]
  end
end
