class ActionDispatch::Routing::RouteSet
  def url_for_with_host_fix(options)
    url_for_without_host_fix(options.merge(
      host: 'localhost:3000',
      locale: 'en'
    ))
  end

  alias_method_chain :url_for, :host_fix
end
