require_relative 'payer'
require_relative 'bill'
require_relative 'dao'

# Registry class that acts as a data store for Payers and
# holds logic for accessing/creating/filtering of Payer
# and Bill objects.
class PayerRegistry
  def initialize
    @collection = {}
  end

  def self.create_from_file
    rows = DAO.read_data
    rows.each_with_object(PayerRegistry.new) do |row, registry|
      registry.create_bill(
        {
          'first_name' => row['first_name'], 'last_name' => row['last_name'],
          'patronymic' => row['patronymic']
        },
        'bill_type' => row['bill_type'], 'total' => row['total'], 'paid' => row['paid']
      )
    end
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

  def by_full_name(full_name)
    @collection[full_name]
  end

  def create_payer(payer_hash)
    return false if has_payer(payer_hash)
    by_payer_hash(payer_hash)
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

  def has_payer(payer_hash)
    full_name = Payer.calculate_full_name(payer_hash)
    @collection.include?(full_name)
  end

  def by_payer_hash(payer_hash)
    full_name = Payer.calculate_full_name(payer_hash)
    add(Payer.new(payer_hash)) unless has_payer(payer_hash)
    @collection[full_name]
  end
end
