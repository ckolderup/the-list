require 'sinatra'
require 'mongoid'
require 'sinatra/mongoid'
require 'haml'

set :mongo_db, 'the-list'

class Entry
  include Mongoid::Document
  field :text, type: String
  field :created_at, type: DateTime
end

get '/' do
  @entries = Entry.all(sort: [[:created_at, :desc]])
  haml :index
end

post '/add' do
  entry = Entry.new(created_at: DateTime.now, text: params[:text])
  entry.save
  redirect '/', 302
end

get '/delete/:id' do
  entry = Entry.first(conditions: { _id: params[:id] })
  entry.destroy
  redirect '/'
end
