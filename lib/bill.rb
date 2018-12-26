# Represents data structure for a single bill and provides
# calculation methods for it.
class Bill
  attr_reader :total, :paid, :type

  def initialize(options)
    @total = Float(options['total'])
    @paid = Float(options['paid'])
    @type = options['bill_type']
  end

  def remaining
    if @total >= @paid
      @total - @paid
    else
      0
    end
  end

  def add_ammount(ammount)
    @paid += ammount
  end

  def to_s
    "#{@type} bill, paid #{@paid} of #{@total}"
  end
end
