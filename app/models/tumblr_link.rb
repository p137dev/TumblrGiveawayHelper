class TumblrLink < ActiveRecord::Base
  # before_save { self.giveawaylink = giveawaylink.downcase }
  TUMBLR_BLOGPOST_REGEX = /\A(http|https):\/\/(\w+).tumblr.com\/post\/(\d+)\/(\S+)\z/
  validates :giveawaylink, presence: true, format: { with: TUMBLR_BLOGPOST_REGEX }
end
