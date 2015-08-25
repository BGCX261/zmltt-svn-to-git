class Photo < ActiveRecord::Base
  has_attachment :content_type => :image, :max_size => 16.megabyte
  belongs_to :banner
  belongs_to :promo
  belongs_to :user
  validates_as_attachment
end
