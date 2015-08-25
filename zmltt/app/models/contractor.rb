class Contractor < ActiveRecord::Base
  has_many :banners
  has_many :contacts
  before_destroy { |record| Contact.destroy_all "contractor_id = #{record.id}"   }
  #validates_presence_of :fio, :message => ": ФИО не может быть пустым"
  #validates_presence_of :tel, :message => ": Телефон не может быть пустым"
  #validates_presence_of :name, :message => ": Название не может быть пустым"
end
