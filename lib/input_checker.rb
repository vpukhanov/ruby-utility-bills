module InputChecker
  def empty_or_blank?(str)
    str.strip.empty?
  end

  def validate_payer(params)
    errors = []
    errors.append('First name is required') if empty_or_blank?(params['first_name'])
    errors.append('Last name is required') if empty_or_blank?(params['last_name'])
    errors
  end
end