require_relative 'bill_types'

# Provides access to helper methods that allow for easier user
# input processing. Includes methods for reading custom types
# like Payer and Bill.
module Input
  def self.string(prompt = '', allow_empty = false)
    loop do
      print_prompt(prompt)
      str = $stdin.gets || ''
      str.strip!
      return str if !str.empty? || allow_empty

      puts 'Please enter a non empty string'
    end
  end

  def self.integer(prompt = '')
    loop do
      print_prompt(prompt)
      begin
        return Integer($stdin.gets, 10)
      rescue ArgumentError, TypeError
        puts 'Please enter an integer number'
      end
    end
  end

  def self.float(prompt = '')
    loop do
      print_prompt(prompt)
      begin
        return Float($stdin.gets)
      rescue ArgumentError, TypeError
        puts 'Please enter a float number'
      end
    end
  end

  def self.range(prompt = '')
    puts "#{prompt}:"
    low = float('Low value')
    loop do
      high = float('High value')
      return low, high if high >= low

      puts "High value should be >= than #{low}"
    end
  end

  def self.money(prompt = '', max = -1)
    loop do
      ammount = float(prompt)
      return ammount if ammount >= 0 && (max == -1 || ammount <= max)

      print 'Please enter a float number >= 0'
      puts " and <= #{max}" if max != -1
    end
  end

  def self.payer
    puts "Enter payer's information:"
    {
      'last_name' => string('Last name'),
      'first_name' => string('First name'),
      'patronymic' => string('Patronymic (optional)', true)
    }
  end

  def self.bill
    puts 'Enter bill information:'
    res = {
      'bill_type' => bill_type,
      'total' => money('Total ammount')
    }
    res['paid'] = money('Paid ammount', res['total'])
    res
  end

  def self.bill_type
    loop do
      type = string('Bill type')
      begin
        return BillTypes.from_string(type)
      rescue RuntimeError
        puts 'Please enter a valid bill type (phone, electricity, rent)'
      end
    end
  end

  def self.print_prompt(prompt = '')
    print "\n#{prompt}> "
  end
end
