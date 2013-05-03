module GPSParser
  extend ActiveSupport::Concern

  GPS_STRING_FORMAT = {
    default: /(\d+) deg (\d+)' (\d+.\d+)\" (N|S|E|W)/i
  }

  # Convert a GPS string to lat/lng
  # @return [Array] lat,lng
  def convert_to_lat_lng(gps_string, format = :default)
    gps_string.scan(GPS_STRING_FORMAT[format]).map do |deg, min, sec, dir|
      sym = %w{S W}.include?(dir) ? "-" : ""
      (sym + (deg.to_f + min.to_f/60 + sec.to_f/3600).to_s).to_f
    end
  end
end
