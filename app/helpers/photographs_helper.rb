module PhotographsHelper
  SHORT_METADATA_KEYS = [
    :model, :lens_type, :aperture, :focal_length, :shutter_speed, :iso,
    :copyright_notice, :creator, :creator_country, :creator_city,
    :date_time_original
  ]

  def photo_tag(photograph, size, opts = {})
    return nil if photograph.nil?
    image = if photograph.standard_image.present?
      photograph.standard_image.thumb(size)
    else
      photograph.image.thumb(size)
    end

    image = if opts[:quality].present?
      image.encode(:jpg, "-quality #{opts[:quality]}")
    else
      image.encode(:jpg, "-quality 90")
    end

    image_tag image.url, alt: photograph.fetch_metadata.title
  end

  def creator_details_for(photograph)
    render partial: "photographs/creator", locals: {
      photograph: photograph
    }
  end

  def metadata_table_for(photograph, opts = {})
    render partial: "photographs/metadata_table", locals: { 
      photograph: photograph,
      opts: opts
    }
  end

  def metadata_values_for_attr(photograph, attr, opts = {})
    attributes = photograph.fetch_metadata.send(attr)
    if opts[:format].present? && opts[:format] == :short
      attributes.keep_if do |key, value|
        SHORT_METADATA_KEYS.include?(key.to_sym)
      end
    else
      attributes
    end
  end

  def parse_and_display_metadata_value(key, value)
    begin
      case key
      when 'date_time_original'
        dt = DateTime::parse(value)
        l(dt, format: :long)
      else
        value
      end
    rescue Exception
      value
    end
  end
end
