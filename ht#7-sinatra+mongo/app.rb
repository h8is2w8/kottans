require 'sinatra'
require 'mongoid'
require 'json/ext'

Dir.glob('./{config,models,helpers}/*.rb').each { |file| require file }

helpers ApplicationHelper

get '/' do
  @cpu_calls = Count.where(name: "cpu").count
  @disk_calls = Count.where(name: "disk").count
  erb :index
end

get '/info/:type' do |type|

  @count = Count.new(name: params[:type])
  @count.save

  if type == "cpu"
    @title = "CPU"
    @storage = `ps -eo pcpu,pid,user,args | sort -k 1 -r | head -6`
  elsif type == "disk"
    @title = "Disk Storage"
    @storage = `df -h`
  else
    redirect to('/')
  end

  @parsed_data = data_parse @storage 
  @titles = @parsed_data.shift.join(' ').split(' ')
    if type == "disk"
    mounted = @titles.pop(2).join(' ')
    @titles << mounted
    end
  erb :info
end