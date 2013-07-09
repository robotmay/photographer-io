module PhotographsHelper
  class DeprecatedPhoto < StandardError; end
  class Processing < StandardError; end

  SHORT_METADATA_KEYS = [
    :model, :lens_type, :aperture, :focal_length, :shutter_speed, :iso,
    :copyright_notice, :creator, :creator_country, :creator_city,
    :date_time_original
  ]

  def photo_tag(photograph, size, opts = {})
    return nil if photograph.nil?

    begin
      raise DeprecatedPhoto if !photograph.has_precalculated_sizes?
      raise Processing if photograph.nil? || photograph.processing?
      
      image = case size
      when :homepage
        photograph.homepage_image
      when :large
        photograph.large_image
      when :thumbnail
        photograph.thumbnail_image
      else
        photograph.thumbnail_image
      end

      raise Processing if image.nil?
      url = image_url(image)

      if match = url.match(/\d+x\d+.jpg/i)
        width, height = match.to_a.last.split(".").first.split("x")
        image_tag url, { 
          alt: photograph.metadata.title,
          width: width,
          height: height
        }.merge(opts)
      else
        image_tag url, {
          alt: photograph.metadata.title
        }.merge(opts)
      end

    rescue Processing
      image_tag "processing_#{size.to_s}.jpg"
    rescue DeprecatedPhoto
      deprecated_photo_tag(photograph, size, opts = {})
    end
  end

  def image_url(image)
    return if image.nil?

    url = if ENV['CDN_HOST']
      image.remote_url(host: ENV['CDN_HOST'])
    else
      image.remote_url
    end

    url.gsub!(/https?:\/\//, "//")
    url.gsub!("////", "//")

    url
  end

  def hidden_image_meta_tag(image)
    url = image_url(image)
    if url.present?
      content_tag(:div, style: "display: none;", itemprop: "image") do
        url.gsub("//", "http://")
      end
    end
  end
  
  def deprecated_photo_tag(photograph, size, opts = {})
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

    image_tag image.url, alt: photograph.metadata.title
  end

  def creator_details_for(photograph)
    render partial: "photographs/creator", locals: {
      photograph: photograph
    }
  end

  def interactions_for(photograph)
    render partial: "photographs/interactions", locals: {
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
    attributes = photograph.metadata.send(attr)
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

  def metadata_typeahead_values(attr = nil)
    @values = Rails.cache.fetch([current_user, :typeahead, attr], expires_in: 5.minutes) do
      @values = Rails.cache.fetch([current_user, :typeahead], expires_in: 10.minutes) do
        keys = Metadata::EDITABLE_KEYS.dup
        [:id, :title, :description, :keywords].each { |a| keys.delete(a) }
        keys.reduce({}) do |hash, key|
          hash[key] = current_user.metadata.map do |m|
            value = m.send(key)
            { value: value, tokens: value.to_s.split(" ") }
          end
          hash[key] = hash[key].keep_if { |val| val[:value].present? }.uniq { |val| val[:value] }
          hash
        end
      end

      if attr.present?
        @values = @values[attr.to_sym]
      else
        @values
      end
    end
  end
end
