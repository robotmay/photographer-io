module PhotographsHelper
  def photo_tag(photograph, size, opts = {})
    image = photograph.image.thumb(size)

    image = if opts[:quality].present?
      image.encode(:jpg, "-quality #{opts[:quality]}")
    else
      image.encode(:jpg, "-quality 90")
    end

    image_tag image.url, alt: photograph.metadata.title
  end

  def metadata_table_for(photograph, opts = {})
    render partial: "photographs/metadata_table", locals: { 
      photograph: photograph,
      opts: opts
    }
  end
end
