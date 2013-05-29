module ApplicationHelper
  def switch_filter_path(from, to)
    path = url_for(params.except(:page))
    path.gsub(from.to_s, to.to_s)
  end

  def md(text)
    $markdown.render(text).html_safe 
  end

  def once(key, &block)
    key = key.to_s
    if user_signed_in?
      unless current_user.seen[key].present?
        current_user.seen[key] = true
        block.call
      end
    end
  end
end
