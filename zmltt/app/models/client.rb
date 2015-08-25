class Client < ActiveRecord::Base
  has_many :contacts
  has_many :orders
  has_many :dogovors
  has_many :rekvizits
  before_destroy { |record| Contact.destroy_all "client_id = #{record.id}"   }
  before_destroy { |record| Rekvizit.destroy_all "client_id = #{record.id}"   }
  before_destroy { |record| Order.destroy_all "client_id = #{record.id}"   }
end
