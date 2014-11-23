require 'sinatra/base'

# Dir.glob('./{config,models,helpers}/*.rb').each { |file| require file }

class CatPower < Sinatra::Base


  configure do
    set :haml, layout: :application
    Mongoid.load!("./config/mongoid.yml")
  end

  get '/' do
    haml '%div.title Hello World'
  end

end