require 'sinatra'
#require 'mongoid'

helpers do
  def data_parse string
  	raw_data = string.split("\n")
    data = raw_data.map { |x| x.split('\s?') }
    if data.first.include?('Mounted')
      mounted = data.first.last(2).join(' ')
      data.first.pop(2)
      data.first << mounted
    end
    data
  end
end

configure do
  set :erb, layout: :application
end 

get '/' do
  erb :index
end

get '/storage' do
  @storage = `df -h`
  @parsed_data = data_parse @storage
  erb :storage
end

get '/cpu' do
  @storage = `ps -eo pcpu,pid,user,args | sort -k 1 -r | head -6`
  @parsed_data = data_parse @storage
  erb :cpu
end