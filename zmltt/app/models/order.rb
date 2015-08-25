class Order < ActiveRecord::Base
  belongs_to :client
  belongs_to :user
  belongs_to :dogovor
  has_many :prices
  has_many :plategs
  has_one :prilojen
  before_destroy { |record| Price.destroy_all "order_id = #{record.id}"   }
  before_destroy { |record| Plateg.destroy_all "order_id = #{record.id}" }
  before_destroy { |record| Prilojen.destroy_all "order_id = #{record.id}" }
end
