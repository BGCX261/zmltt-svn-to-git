class Special < ActiveRecord::Base
  has_attachment :max_size => 16.megabyte
  validates_as_attachment
end
