require 'sinatra'
require 'sinatra/reloader' if development?

require_relative 'lib/payer_registry'

configure do
  set :payers, PayerRegistry.create_from_file
end

get '/' do
  @payers = settings.payers.all
  erb :index
end