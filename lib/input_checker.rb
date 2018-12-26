require_relative 'bill_types'

module InputChecker
  def empty_or_blank?(str)
    str.strip.empty?
  end

  def to_float(str)
    begin
      Float(str)
    rescue ArgumentError, TypeError
      nil
    end
  end

  def to_integer(str)
    begin
      Integer(str)
    rescue ArgumentError, TypeError
      nil
    end
  end

  def to_bill_type(str)
    begin
      BillTypes.from_string(str)
    rescue
      nil
    end
  end

  def validate_payer(params)
    errors = []
    errors.append('First name is required') if empty_or_blank?(params['first_name'])
    errors.append('Last name is required') if empty_or_blank?(params['last_name'])
    errors
  end

  def validate_bill(params)
    errors = []
    params['total'] = to_float(params['total'])
    params['paid'] = to_float(params['paid'])
    errors.append('Total ammount should be a float number') if params['total'].nil?
    errors.append('Paid ammount should be a float number') if params['paid'].nil?
    return errors unless errors.empty?
    errors.append('Total ammount should be > 0') if params['total'] <= 0
    errors.append('Paid ammount should be >= 0') if params['paid'] < 0
    errors.append('Paid ammount should be <= total ammount') if params['paid'] > params['total']
    params['bill_type'] = to_bill_type(params['bill_type'])
    errors.append('Selected bill type is unknown') if params['bill_type'].nil?
    errors
  end

  def validate_payment(params, bill)
    errors = []
    params['to_pay'] = to_float(params['to_pay'])
    errors.append('Ammount to pay should be a float number') if params['to_pay'].nil?
    return errors unless errors.empty?
    errors.append('Ammount to pay should be > 0') if params['to_pay'] <= 0
    errors.append('Ammount to pay should be <= remaining ammount') if params['to_pay'] > bill.remaining
    errors
  end
end