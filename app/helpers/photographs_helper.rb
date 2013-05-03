module PhotographsHelper
  def photo_tag(photograph, size)
    image_tag photograph.image.thumb(size).jpg.url, alt: photograph.metadata.title
  end

  def metadata_table_for(photograph, opts = {})
    render partial: "photographs/metadata_table", locals: { 
      photograph: photograph,
      opts: opts
    }
  end
end
