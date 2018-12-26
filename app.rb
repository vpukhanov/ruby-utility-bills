require 'sinatra'
require 'sinatra/reloader' if development?

require_relative 'lib/payer_registry'
require_relative 'lib/input_checker'
require_relative 'lib/bill_types'
require_relative 'lib/bill'

helpers InputChecker

configure do
  set :payers, PayerRegistry.create_from_file
end

get '/' do
  @payers = settings.payers.all.sort_by(&:to_s)
  erb :index
end

get '/payers/new' do
  erb :new_payer
end

post '/payers/new' do
  @errors = validate_payer(params)
  if @errors.empty?
    added = settings.payers.create_payer(params) if @errors.empty?
    @errors.append('Payer with the same full name already exists') unless added
  end
  unless @errors.empty?
    @first_name = params['first_name']
    @last_name = params['last_name']
    @patronymic = params['patronymic']
    return erb :new_payer
  end
  redirect to('/')
end

get '/bills/:full_name' do
  @payer = settings.payers.by_full_name(params['full_name'])
  return redirect to('/404') unless @payer
  @bills = @payer.bills.each_with_index.map do |bill, index|
    { 'bill' => bill, 'original_index' => index }
  end.sort_by { |row| -row['bill'].remaining }
  erb :bills
end

get '/bills/:full_name/new' do
  @payer = settings.payers.by_full_name(params['full_name'])
  return redirect to('/404') unless @payer
  @bill_types = BillTypes::ALL
  erb :new_bill
end

post '/bills/:full_name/new' do
  @payer = settings.payers.by_full_name(params['full_name'])
  return redirect to('/404') unless @payer
  @errors = validate_bill(params)
  unless @errors.empty?
    @bill_types = BillTypes::ALL
    @bill_type = params['bill_type']
    @total = params['total']
    @paid = params['paid']
    return erb :new_bill
  end
  @payer.add_bill(Bill.new(params))
  redirect to('/bills/' + URI.escape(params['full_name']))
end

get '/bills/:full_name/:index/pay' do
  @payer = settings.payers.by_full_name(params['full_name'])
  return redirect to('/404') unless @payer
  @bill = @payer.bills[to_integer(params['index'])]
  return redirect to('/404') unless @bill and !@bill.remaining.zero?
  erb :pay_bill
end

post '/bills/:full_name/:index/pay' do
  @payer = settings.payers.by_full_name(params['full_name'])
  return redirect to('/404') unless @payer
  @bill = @payer.bills[to_integer(params['index'])]
  return redirect to('/404') unless @bill and !@bill.remaining.zero?
  @errors = validate_payment(params, @bill)
  unless @errors.empty?
    @to_pay = params['to_pay']
    return erb :pay_bill
  end
  @bill.add_ammount(@params['to_pay'])
  redirect to('/bills/' + URI.escape(params['full_name']))
end