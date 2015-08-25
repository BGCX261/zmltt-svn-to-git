class Price < ActiveRecord::Base
  belongs_to :order
  belongs_to :banner
  belongs_to :extra

  #named_scope :dopusl, lambda {|*args|{:conditions => {:banner_id => args[0], :order_id => args[1]}}}
end
