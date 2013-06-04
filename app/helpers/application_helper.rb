module ApplicationHelper
  def blog_path
    ENV['BLOG_URL']
  end

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

  def w3c_date(date)
    date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end

  require 'thread/channel'

  def cache_each(enumerable, key, options = {}, &block)
    keys = {}
    enumerable.each do |e|
      keys[e.id] = [e.cache_key, key].join("/")
    end

    hits = Rails.cache.read_multi(keys.values, options)

    return_values = []
    to_write = Thread.channel

    Thread.new do
      while cache_write = channel.receive
        cache_write.call
      end
    end

    enumerable.each do |e|
      this_key = keys[e.id]

      value = if hits.include?(this_key)
        hits[this_key]
      else
        val = block.call(e)
        to_write.send -> { Rails.cache.write(this_key, val, options) }
        val
      end

      return_values << value
    end

    return return_values.join
  end
end
