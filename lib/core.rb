require_relative 'menu'
require_relative 'payer_registry'
require_relative 'dao'

# Main class of the application, interactive layer between the user
# and the database.
class Core
  attr_accessor :menu, :payers

  def initialize
    @menu = create_menu
    @payers = create_registry
  end

  def run
    puts 'RB Utility Bills'
    puts 'Utility bill payers management application'
    puts '=========================================='

    @menu.start
  end

  def create_registry
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

  def create_menu
    menu = Menu.new
    menu.add_action('Add a bill', -> { add_bill })
    menu.add_action('Remove a bill', -> { remove_bill })
    menu.add_action("List payer's bills with total", -> { list_bills })
    menu.add_action('List payers by name', -> { list_payers })
    menu.add_action('List payers in debt range', -> { list_payers_in_range })
    menu.add_action('Pay a bill', -> { pay_bill })
    menu.add_action('Save changes', -> { save_changes })
    menu.add_stop_action('Exit')
    menu
  end

  def add_bill
    payer_data = Input.payer
    bill_data = Input.bill
    @payers.create_bill(payer_data, bill_data)
  end

  def remove_bill
    payer = @menu.select('Choose a payer', @payers.all)
    unless payer
      puts 'There are no tracked payers'
      return
    end
    bill = @menu.select('Choose a bill', payer.bills)
    puts 'This payer has no bills' unless bill
    payer.delete_bill(bill) if bill
  end

  def list_bills
    payer = @menu.select('Choose a payer', @payers.all)
    unless payer
      puts 'There are no tracked payers'
      return
    end
    puts "#{payer}'s bills:"
    @menu.list(payer.bills)
    puts "Remaining ammount: #{payer.remaining_debt} of #{payer.total_debt}"
  end

  def list_payers
    puts 'Payers listed by name:'
    @menu.list(@payers.all.sort_by(&:to_s))
  end

  def list_payers_in_range
    low, high = Input.range('Enter debt range')
    puts 'Payers with debt in specified range:'
    @menu.list(@payers.in_debt_range(low, high))
  end

  def pay_bill
    payer = @menu.select('Choose a payer', @payers.all)
    unless payer
      puts 'There are no tracked payers'
      return
    end
    bill = @menu.select('Choose a bill to pay', payer.unpaid_bills)
    unless bill
      puts 'There are no bills to pay'
      return
    end
    ammount = Input.money('Enter ammount to pay', bill.remaining)
    bill.add_ammount(ammount)
  end

  def save_changes
    DAO.write_data(@payers.to_rows)
    puts 'Data saved!'
  end
end
