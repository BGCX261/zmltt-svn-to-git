module BannerHelper
  
  def button_to_remote (name, options ={}, html_options = {})
    button_to_function(name, remote_function(options), html_options)
  end
  
  def loaddek(price)
    ret = Hash.new()
    rumonthes().each do |m|
      Price.find(:all, :conditions => {:banner_id => price.id, :order_id => session[:order], :month => m}).each do |p|
        ret[m+p.wtf] = p.coast if p.wtf =~ /\d/
      end
    end
    return ret
  end
  
  def addel(id,doing)
    if doing=="add"
      label="+" 
      link_to_remote label, 
        :update => 'main_div', 
        :method => 'get', 
        :before => "Element.show('spinner')", :success => "Element.hide('spinner')", 
        :url => {:controller =>'office', :action => "addprice", :do =>doing, :id => id}
    else
      label="-" 
      link_to_remote label, 
        :update => 'add_div_'+id.to_s, 
        :method => 'get',
        :confirm => 'Точно исключить из комерческого предложения?',
        :before => "Element.show('spinner')", :success => "Element.hide('spinner')", 
        :url => {:controller =>'banner', :action => "recycler", :do =>doing, :id => id}
    end

  end
  
  def showtip(tp)  
    if (not session[:tip].nil?) and session[:tip].include?(tp)
      label=tp
      doit="add"
    else
      label="<div class=bold>"+tp+"</div>"
      doit="del"
    end
    link_to_remote label, 
      :update => 'tip_div_'+tp, 
      :method => 'get', 
      :before => "Element.show('spinner')", :success => "Element.hide('spinner')", 
      :url => {:controller =>'banner', :action => 'tip', :do =>doit, :tip => tp}
  end
  
  def showpodr(tp)  
    if (not session[:spodr].nil?) and session[:spodr].include?(tp)
      label="нет"
      doit="add"
    else
      label="да"
      doit="del"
    end
    link_to_remote label, 
      :update => 'spodr_div_'+tp, 
      :method => 'get', 
      :before => "Element.show('spinner')", :success => "Element.hide('spinner')", 
      :url => {:action => 'tippodr', :do =>doit, :spodr => tp}
  end
  
  def coast(id,month)
    price = Price.find(:first, :conditions => {:order_id => session[:order], :banner_id => id, :month => month})
    return 'нет' if price.nil? or price.coast.size <1
    price.coast
  end
  
  #  def erasem(id,m)
  #    if m.nil?
  #      @month = Month.new
  #      @month.banner_id = id
  #      @month.save
  #      m=@month
  #    end
  #    m.january = coast(id,'Январь')
  #    m.february = coast(id,'Февраль')
  #    m.march = coast(id,'Март')
  #    m.april = coast(id,'Апрель')
  #    m.may = coast(id,'Май')
  #    m.june = coast(id,'Июнь')
  #    m.july = coast(id,'Июль')
  #    m.august = coast(id,'Август')
  #    m.september = coast(id,'Сентябрь')
  #    m.october = coast(id,'Октябрь')
  #    m.november = coast(id,'Ноябрь')
  #    m.december = coast(id,'Декабрь')
  #    return m
  #  end
end
