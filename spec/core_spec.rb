require 'core'
require 'menu'
require 'payer_registry'
require 'input'
require 'dao'

RSpec.describe Core do
  before do
    @core = Core.new
    @core.menu = Menu.new
    @core.payers = PayerRegistry.new

    @menu = @core.menu
    @payers = @core.payers

    @payer = double('Payer')
    @bill = double('Bill')

    $stdout = StringIO.new
  end

  context '#run' do
    it 'should print welcome message and start menu' do
      expect($stdout).to receive(:puts).at_least(1).times
      expect(@menu).to receive(:start)
      @core.run
    end
  end

  context '#add_bill' do
    it 'should request to input data and create bill' do
      pdata = double('Hash')
      bdata = double('Hash')

      expect(Input).to receive(:payer).and_return(pdata)
      expect(Input).to receive(:bill).and_return(bdata)
      expect(@payers).to receive(:create_bill).with(pdata, bdata)

      @core.add_bill
    end
  end

  context '#remove_bill' do
    it 'should ask to select a payer and bill and delete a bill' do
      bill_one = double('Bill')
      bill_two = double('Bill')
      expect(@menu).to receive(:select).with(any_args, @payers.all).and_return(@payer)
      expect(@payer).to receive(:bills).and_return([bill_one, bill_two])
      expect(@menu).to receive(:select).with(any_args, [bill_one, bill_two]).and_return(bill_two)
      expect(@payer).to receive(:delete_bill).with(bill_two)
      @core.remove_bill
    end

    it 'should return if there are no payers' do
      expect(@menu).to receive(:select).with(any_args, @payers.all).and_return(nil)
      expect($stdout).to receive(:puts).at_least(1).times
      @core.remove_bill
    end

    it 'should return if there are no bills' do
      expect(@menu).to receive(:select).with(any_args, @payers.all).and_return(@payer)
      expect(@payer).to receive(:bills).and_return([])
      expect(@menu).to receive(:select).with(any_args, []).and_return(nil)
      expect($stdout).to receive(:puts).at_least(1).times
      @core.remove_bill
    end
  end

  context '#list_bills' do
    it 'should ask to select a player and list bills and total' do
      expect(@menu).to receive(:select).with(any_args, @payers.all).and_return(@payer)
      expect(@payer).to receive(:bills).and_return([@bill])
      expect(@menu).to receive(:list).with([@bill])
      expect(@payer).to receive(:remaining_debt)
      expect(@payer).to receive(:total_debt)
      @core.list_bills
    end

    it 'should return if there are no payers' do
      expect(@menu).to receive(:select).with(any_args, @payers.all).and_return(nil)
      expect($stdout).to receive(:puts).at_least(1).times
      @core.list_bills
    end
  end

  context '#list_payers' do
    it 'should sort payers by name' do
      expect(@payers).to receive(:all).and_return(%w[c b a])
      expect(@menu).to receive(:list).with(%w[a b c])
      @core.list_payers
    end
  end

  context '#list_payers_in_range' do
    it 'should read range and list specified payers' do
      expect(Input).to receive(:range).and_return([1, 5])
      expect(@payers).to receive(:in_debt_range).with(1, 5).and_return([1, 2, 3])
      expect(@menu).to receive(:list).with([1, 2, 3])
      @core.list_payers_in_range
    end
  end

  context '#pay_bill' do
    it 'should select a payer, a bill and ammount and pay it' do
      bill_one = double('Bill')
      bill_two = double('Bill')
      expect(@menu).to receive(:select).with(any_args, @payers.all).and_return(@payer)
      expect(@payer).to receive(:unpaid_bills).and_return([bill_one, bill_two])
      expect(@menu).to receive(:select).with(any_args, [bill_one, bill_two]).and_return(bill_two)
      expect(bill_two).to receive(:remaining).and_return(200)
      expect(Input).to receive(:money).with(any_args, 200).and_return(100)
      expect(bill_two).to receive(:add_ammount).with(100)
      @core.pay_bill
    end

    it 'should return if there are no payers' do
      expect(@menu).to receive(:select).with(any_args, @payers.all).and_return(nil)
      expect($stdout).to receive(:puts).at_least(1).times
      @core.pay_bill
    end

    it 'should return if there are no unpaid bills' do
      expect(@menu).to receive(:select).with(any_args, @payers.all).and_return(@payer)
      expect(@payer).to receive(:unpaid_bills).and_return([])
      expect(@menu).to receive(:select).and_return(nil)
      expect($stdout).to receive(:puts).at_least(1).times
      @core.pay_bill
    end
  end

  context '#save_changes' do
    it 'calls to_rows and writes data' do
      expect(@payers).to receive(:to_rows).and_return('ababab')
      expect(DAO).to receive(:write_data).with('ababab')
      @core.save_changes
    end
  end
end
