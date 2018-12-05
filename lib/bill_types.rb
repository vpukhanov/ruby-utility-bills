# Gives access to bill type constants which can be used
# across the program for consistency. Provides a method
# to convert a string to bill type constant.
module BillTypes
  RENT = :rent
  ELECTRICITY = :electricity
  PHONE = :phone

  def self.from_string(str)
    case str.downcase
    when 'rent'
      self::RENT
    when 'electricity'
      self::ELECTRICITY
    when 'phone'
      self::PHONE
    else
      raise "Unknown bill type '#{str}'"
    end
  end
end
