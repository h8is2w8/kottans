configure do
  # set global layout
  set haml, layout: :application

  # load db settings
  Mongoid.load!("./mongoid.yml")
end