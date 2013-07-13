class SwitchNlLocalesToNlNl < ActiveRecord::Migration
  def change
    User.where(locale: "nl").each do |user|
      user.update_attribute(:locale, "nl_NL")
    end
  end
end
