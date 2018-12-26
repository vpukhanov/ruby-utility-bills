# Represents data structure for a single payer and provides
# methods for debt calculation and name printing.
class Payer
  attr_reader :bills, :last_name, :first_name, :patronymic

  def initialize(options)
    @last_name = options['last_name'].strip
    @first_name = options['first_name'].strip
    @patronymic = options['patronymic'].strip if options['patronymic']
    @bills = []
  end

  def add_bill(bill)
    @bills.append(bill)
  end

  def delete_bill(bill)
    @bills.delete(bill)
  end

  def total_debt
    @bills.sum(&:total)
  end

  def remaining_debt
    @bills.sum(&:remaining)
  end

  def unpaid_bills
    @bills.select { |bill| bill.remaining > 0 }
  end

  def to_s
    Payer.calculate_full_name(
      'last_name' => @last_name,
      'first_name' => @first_name,
      'patronymic' => @patronymic
    )
  end

  def self.calculate_full_name(hash)
    full_name = "#{hash['last_name'].strip} #{hash['first_name'].strip}"
    full_name += " #{hash['patronymic'].strip}" if hash['patronymic'] && !hash['patronymic'].empty?
    full_name
  end
end
