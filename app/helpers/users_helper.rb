module UsersHelper
  def follow_user_button(user)
    if user_signed_in? && user != current_user
      if current_user.following?(user)
        following = current_user.follower_followings.find_by(followee_id: user.id)
        link_to following_path(following), method: :delete, class: "button unfollow alert tiny expand" do
          t("followings.unfollow")
        end
      else
        link_to user_followings_path(user), method: :post, class: "button follow secondary tiny expand" do
          t("followings.follow")
        end
      end
    end
  end
end
