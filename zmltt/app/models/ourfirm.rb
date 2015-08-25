class Ourfirm < ActiveRecord::Base
  has_many :dogovors
  has_many :rekvizits
end
