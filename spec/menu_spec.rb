require 'menu'

RSpec.describe Menu do
  before do
    @menu = Menu.new
    $stdout = StringIO.new
  end

  context '#add_action' do
    it 'should add action to the list' do
      @menu.add_action('Test', -> {})
      expect(@menu.actions.length).to eq(1)
    end
  end

  context '#add_stop_action' do
    it 'should add stop action to the list' do
      @menu.add_stop_action('Stop')
      expect(@menu.actions[0][:action].call).to eq(:stop)
    end
  end

  context '#start' do
    it 'should run until stop action is selected' do
      @menu.add_action('Test', -> {})
      expect(@menu).to receive(:run_step).exactly(5).times.and_return(1, 2, 3, 4, :stop)
      @menu.start
    end

    it 'should pick an action using select' do
      @menu.add_stop_action('Stop')
      expect(@menu).to receive(:select).and_return(@menu.actions[0])
      @menu.start
    end
  end

  context '#select' do
    it 'should print a prompt' do
      expect($stdin).to receive(:gets).and_return("1\n")
      expect($stdout).to receive(:puts).with('Test:')
      allow($stdout).to receive(:puts)
      @menu.select('Test', [1, 2, 3])
    end

    it 'should list variants' do
      expect($stdin).to receive(:gets).and_return("1\n")
      expect(@menu).to receive(:list).with([1])
      @menu.select('Test', [1])
    end

    it 'should return selected variant' do
      expect($stdin).to receive(:gets).and_return("2\n")
      result = @menu.select('Test', %i[first second third])
      expect(result).to eq(:second)
    end

    it 'should return nil if no variants given' do
      expect(@menu.select('Test', [])).to eq(nil)
    end

    it 'should repeat prompt if entered number is too high or too low' do
      expect($stdin).to receive(:gets).and_return("-1\n", "5\n", "3\n")
      result = @menu.select('Test', %i[first second third])
      expect(result).to eq(:third)
    end
  end

  context '#list' do
    it 'should print a message if variants are empty' do
      expect($stdout).to receive(:puts).with('Nothing to list')
      @menu.list([])
    end

    it 'should print all items' do
      expect($stdout).to receive(:puts).with('1) 1')
      expect($stdout).to receive(:puts).with('2) 2')
      expect($stdout).to receive(:puts).with('3) 3')
      @menu.list([1, 2, 3])
    end

    it 'should use block for printing if given' do
      expect($stdout).to receive(:puts).with('1) 1')
      expect($stdout).to receive(:puts).with('2) 2')
      expect($stdout).to receive(:puts).with('3) 3')
      @menu.list([2, 3, 4]) { |val| val - 1 }
    end
  end
end
