require 'sinatra'
require 'sinatra/reloader' if development?

require_relative 'lib/payer_registry'
require_relative 'lib/input_checker'

helpers InputChecker

configure do
  set :payers, PayerRegistry.create_from_file
end

get '/' do
  @payers = settings.payers.all
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