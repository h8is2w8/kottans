module ApplicationHelper
	
  def data_parse string
    raw_data = string.split("\n")
    data = raw_data.map { |x| x.split('\s?') }
    data
  end
end