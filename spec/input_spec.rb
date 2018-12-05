require 'input'
require 'bill_types'

RSpec.describe Input do
  before do
    $stdout = StringIO.new
  end

  context '::string' do
    it 'should print prompt' do
      expect($stdin).to receive(:gets).and_return('1')
      expect(Input).to receive(:print_prompt)
      Input.string
    end

    it 'should repeat until string is not empty' do
      expect($stdin).to receive(:gets).and_return("\n", "    \n", nil, 'Test')
      expect($stdout).to receive(:puts).at_least(3).times
      expect(Input.string).to eq('Test')
    end

    it 'should allow empty string if specified' do
      expect($stdin).to receive(:gets).and_return("\n")
      expect(Input.string('', true)).to eq('')
    end
  end

  context '::integer' do
    it 'should print prompt' do
      expect($stdin).to receive(:gets).and_return('1')
      expect(Input).to receive(:print_prompt)
      Input.integer
    end

    it 'should return a number' do
      expect($stdin).to receive(:gets).and_return("10\n")
      expect(Input.integer).to eq(10)
    end

    it 'should repeat until number is entered' do
      expect($stdin).to receive(:gets).and_return("\n", "    \n", "abc\n", "5bz\b", "0.02\n", "-15\n")
      expect($stdout).to receive(:puts).at_least(5).times
      expect(Input.integer).to eq(-15)
    end
  end

  context '::float' do
    it 'should print prompt' do
      expect($stdin).to receive(:gets).and_return('1')
      expect(Input).to receive(:print_prompt)
      Input.float
    end

    it 'should return a float number' do
      expect($stdin).to receive(:gets).and_return("0.25\n")
      expect(Input.float).to eq(0.25)
    end

    it 'should repeat until number is entered' do
      expect($stdin).to receive(:gets).and_return("\n", "    \n", "abc\n", "5bz\b", "0.02\n")
      expect($stdout).to receive(:puts).at_least(4).times
      expect(Input.float).to eq(0.02)
    end
  end

  context '::range' do
    it 'should print prompt' do
      expect($stdin).to receive(:gets).and_return("1\n", "2\n")
      expect($stdout).to receive(:puts)
      Input.range
    end

    it 'should repeat until two ordered numbers are entered' do
      expect($stdin).to receive(:gets).and_return("a\n", "5b\n", "10\n", "z\n", "15\n")
      expect($stdout).to receive(:puts).at_least(3).times
      expect(Input.range).to eq([10, 15])
    end

    it 'should ignore high limit lower than low limit' do
      expect($stdin).to receive(:gets).and_return("10\n", "5\n", "9\n", "-1\n", "20\n")
      expect($stdout).to receive(:puts).at_least(3).times
      expect(Input.range).to eq([10, 20])
    end
  end

  context '::money' do
    it 'should print prompt' do
      expect($stdin).to receive(:gets).and_return("1\n")
      expect(Input).to receive(:print_prompt).at_least(1).times
      Input.money
    end

    it 'should repeat until number is entered' do
      expect($stdin).to receive(:gets).and_return("\n", "    \n", "abc\n", "5bz\b", "0.02\n")
      expect(Input.money).to eq(0.02)
    end

    it 'should ignore negative numbers' do
      expect($stdin).to receive(:gets).and_return("-5\n", "-0.01\n", "20\n")
      expect(Input.money).to eq(20)
    end

    it 'should take maximum into account if specified' do
      expect($stdin).to receive(:gets).and_return('5', '4', '2')
      expect(Input.money('', 3)).to eq(2)
    end
  end

  context '::payer' do
    it 'should read 3 strings' do
      expect(Input).to receive(:string).and_return('Ivanov', 'Ivan', 'Ivanovich')
      Input.payer
    end

    it 'should accept empty patronymic' do
      expect($stdin).to receive(:gets).and_return('Doe', 'John', '')
      expect(Input.payer['patronymic']).to eq('')
    end

    it 'should return last_name, first_name and patronymic' do
      expect(Input).to receive(:string).and_return('Ivanov', 'Ivan', 'Ivanovich')
      expect(Input.payer).to eq('last_name' => 'Ivanov', 'first_name' => 'Ivan', 'patronymic' => 'Ivanovich')
    end
  end

  context '::bill' do
    it 'should read bill_type and 2 money' do
      expect(Input).to receive(:bill_type).and_return(BillTypes::PHONE)
      expect(Input).to receive(:money).and_return(50, 25)
      Input.bill
    end

    it 'should limit paid ammount by total ammount' do
      expect(Input).to receive(:bill_type).and_return(BillTypes::PHONE)
      expect(Input).to receive(:money).and_return(50)
      expect(Input).to receive(:money).with(any_args, 50).and_return(20)
      Input.bill
    end

    it 'should return bill_type, total and paid' do
      expect(Input).to receive(:bill_type).and_return(BillTypes::PHONE)
      expect(Input).to receive(:money).and_return(50, 25)
      expect(Input.bill).to eq('bill_type' => BillTypes::PHONE, 'total' => 50, 'paid' => 25)
    end
  end

  context '::bill_type' do
    it 'should read bill_type' do
      expect($stdin).to receive(:gets).and_return('phone')
      expect(Input.bill_type).to eq(BillTypes::PHONE)
    end

    it 'should ignore invalid bill_types' do
      expect($stdin).to receive(:gets).and_return('test', 'my', 'this', 'rent')
      expect($stdout).to receive(:puts).at_least(3).times
      expect(Input.bill_type).to eq(BillTypes::RENT)
    end
  end
end
