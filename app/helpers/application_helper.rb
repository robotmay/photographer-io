module ApplicationHelper
  def switch_filter_path(from, to)
    request.fullpath.gsub(from.to_s, to.to_s)
  end
end
