module PhotographsHelper
  def metadata_table_for(photograph, opts = {})
    render partial: "photographs/metadata_table", locals: { 
      photograph: photograph,
      opts: opts
    }
  end
end
