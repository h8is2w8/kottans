configure do
  set :erb, layout: :application
  Mongoid.load!("./mongoid.yml")
end