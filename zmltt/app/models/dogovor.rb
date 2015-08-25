class Dogovor < ActiveRecord::Base
  has_many :orders
  belongs_to :client
  belongs_to :ourfirm
end
