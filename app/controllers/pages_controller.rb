class PagesController < ApplicationController
  respond_to :html

  def home
    @top_photos = Rails.cache.fetch([:home, :top_photos], expires_in: 10.minutes) do
      Photograph.landscape.recommended(current_user, 10)
    end

    respond_with @top_photos
  end

  def stats
    if ENV['STATS_API_KEY'].present? && params['api_key'] == ENV['STATS_API_KEY']
      latest_photo = Photograph.public.order("created_at DESC").first

      stats = {
        cache: Rails.cache.stats,
        redis: Redis.current.info,
        photographs: {
          total: Photograph.count,
          latest: {
            id: latest_photo.id,
            title: latest_photo.metadata.title,
            thumb: latest_photo.thumbnail_image.remote_url(host: ENV['CDN_HOST'])
          }
        },
        users: {
          total: User.count,
          invited: User.where.not(invited_by_id: nil).count,
          accepted_invites: User.where.not(invitation_accepted_at: nil).count
        }
      }

      respond_with stats do |f|
        f.json { render json: stats }
      end
    else
      head :not_found
    end
  end
end
