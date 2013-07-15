if ENV['GOOGLE_ANALYTICS_ID'].present?
  $gabba = Gabba::Gabba.new(ENV['GOOGLE_ANALYTICS_ID'], ENV['DOMAIN'])
end
