Datagrid.configure do |config|

  # Defines date formats that can be used to parse date.
  # Note that multiple formats can be specified but only first format used to format date as string.
  # Other formats are just used for parsing date from string in case your App uses multiple.
  config.date_formats = ["%m/%d/%Y", "%Y-%m-%d"]

  # Defines timestamp formats that can be used to parse timestamp.
  # Note that multiple formats can be specified but only first format used to format timestamp as string.
  # Other formats are just used for parsing timestamp from string in case your App uses multiple.
  config.datetime_formats = ["%m/%d/%Y %h:%M", "%Y-%m-%d %h:%M:%s"]


end