class Metadata < ActiveRecord::Base
  include IdentityCache
  include GPSParser
  include PgSearch

  belongs_to :photograph
  has_one :user, through: :photograph

  store_accessor :image, :lat
  store_accessor :image, :lng

  validates :photograph_id, presence: true

  pg_search_scope :fulltext_search,
                  against: [:title, :description],
                  using: {
                    tsearch: { 
                      dictionary: 'english',
                      tsvector_column: 'search_vector'
                    }
                  }

  scope :with_keyword, lambda { |keyword|
    with_keywords([keyword])
  }

  scope :with_keywords, lambda { |keywords|
    keywords = keywords.map { |kw| "\"#{kw}\"" }.join(",")
    where("metadata.keywords @> ?", "{#{keywords}}")
  }

  before_create :extract_from_photograph
  def extract_from_photograph
    exif = photograph.exif

    self.title        = exif.title
    self.description  = exif.description
    self.keywords     = exif.keywords

    self.camera = fetch_from_exif(exif, [
      :make, :model, :serial_number, :camera_type, :lens_type, :lens_model,
      :max_focal_length, :min_focal_length, :max_aperture, :min_aperture,
      :num_af_points, :sensor_width, :sensor_height
    ])

    self.settings = fetch_from_exif(exif, [
      :orientation, :fov, :aperture, :focal_length,
      :shutter_speed, :iso, :exposure_program, :exposure_mode,
      :metering_mode, :flash, :drive_mode, :digital_zoom, :macro_mode,
      :self_timer, :quality, :record_mode, :easy_mode, :contrast,
      :saturation, :sharpness, :focus_range, :auto_iso, :base_iso,
      :measured_ev, :target_aperture, :target_exposure_time, :white_balance,
      :camera_temperature, :flash_guide_number, :flash_exposure_comp,
      :aeb_bracket_value, :focus_distance_upper, :focus_distance_lower,
      :nd_filter, :flash_sync_speed_av, :shutter_curtain_sync, :mirror_lockup,
      :bracket_mode, :bracket_value, :bracket_shot_number, :hyperfocal_distance,
      :circle_of_confusion
    ])

    self.creator = fetch_from_exif(exif, [
      :copyright_notice, :rights, :creator, :creator_country, :creator_city
    ])

    self.image = fetch_from_exif(exif, [
      :color_space, :image_width, :image_height, :gps_position,
      :flash_output, :gamma, :image_size, :date_created, :date_time_original
    ])

    convert_lat_lng
  end

  before_save :convert_lat_lng
  def convert_lat_lng
    gps_position = image['gps_position'] || image[:gps_position]
    if gps_position.present?
      self.lat, self.lng = convert_to_lat_lng(gps_position)      
    end
  end

  def keywords=(value)
    if value.is_a?(String)
      value = value.split(",").map(&:strip)
    end

    super(value)
  end

  def keywords
    super || []
  end

  def keywords_string
    keywords.join(", ") unless keywords.nil?
  end

  def has_text?
    title.present? || description.present?
  end

  private
  def fetch_from_exif(exif, keys = [])
    return_hash = {}

    exif.to_hash.each do |key, value|
      key = key.underscore.to_sym
      if keys.include?(key)
        return_hash[key] = value
      end
    end

    return_hash
  end
end
