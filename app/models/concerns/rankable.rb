module Rankable
  extend ActiveSupport::Concern
  include Redis::Objects

  counter :score

end
