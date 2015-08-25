class Promo < ActiveRecord::Base
  has_many :photos
  before_destroy { |record| Photo.destroy_all "promo_id = #{record.id}"   }
end
