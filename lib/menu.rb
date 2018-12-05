require_relative 'input'

# Provides the core functionality of command line interface:
# selecting an action from list of actions and viewing a
# list of variants.
class Menu
  attr_reader :actions

  def initialize
    @actions = []
  end

  def add_action(description, action)
    @actions.append(
      description: description,
      action: action
    )
  end

  def add_stop_action(description)
    @actions.append(
      description: description,
      action: -> { :stop }
    )
  end

  def start
    loop do
      break if run_step == :stop

      puts
    end
  end

  def select(prompt, variants, &block)
    return nil if !variants || variants.empty?

    puts "#{prompt}:"
    list(variants, &block)
    variants[read_user_choice(variants)]
  end

  def list(variants)
    puts 'Nothing to list' if variants.empty?
    variants.each_with_index do |variant, index|
      text = variant
      text = yield(variant) if block_given?
      puts "#{index + 1}) #{text}"
    end
  end

  private

  def run_step
    selected = select('Choose an action', @actions) { |action| action[:description] }
    selected[:action].call
  end

  def read_user_choice(variants)
    loop do
      choice = Input.integer
      return choice - 1 if valid_choice?(choice, variants)

      puts "Choose between 1 and #{variants.length}"
    end
  end

  def valid_choice?(choice, variants)
    choice >= 1 && choice <= variants.length
  end
end
