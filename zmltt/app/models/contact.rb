class Contact < ActiveRecord::Base
  belongs_to :client
  belongs_to :contractor
  has_many :phones

  before_destroy { |record| Phone.destroy_all "contact_id = #{record.id}"   }
end
