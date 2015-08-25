class Banner < ActiveRecord::Base
  has_many :photos
  has_many :prices
  has_many :onlines
  belongs_to :contractor
  before_destroy { |record| Photo.destroy_all "banner_id = #{record.id}"   }
  before_destroy { |record| Photo.destroy_all "online_id = #{record.id}"   }
end
