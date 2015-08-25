# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def easysave(frm,url)
    observe_form frm,
      :url => url,
      :frequency => 1
  end
  
  def find_online(id)
    Online.find(:all,:conditions=>{:banner_id=>id})
  end
  
  def first_online(id)
    on=Online.find(:first,:conditions=>{:banner_id=>id})
    if(on.nil?)
      on = Online.new()
      on.coast=""
    end
    return on;
  end
  
  def online_size(banner)
    first='0'
    second='0'
    third='0'
    time = Time.now
    onlines=Online.find(:all,:conditions=>{:banner_id=>banner.id})
    return "" if(onlines.size==0)
    onlines.each do |on|
      if banner.tp!='Перетяжки'
        month = on.databegin.month
        first='1' if (month - time.month == 1)
        second='1' if (month - time.month == 2)
        third='1' if (month - time.month == 3)
        month +=12
        first='1' if (month - time.month == 1)
        second='1' if (month - time.month == 2)
        third='1' if (month - time.month == 3)
      else
        if ((on.databegin - Time.now)/86400 < 10)
          first='1';
        elsif ((on.databegin - Time.now)/86400 < 20)
          second='1';
        elsif ((on.databegin - Time.now)/86400 < 30)
          third='1';
        end
      end
    end
    return "http://zimaletto.su/images/dots/interval_#{first}#{second}#{third}.png"
  end
  
  def showdata(type, online)
    if (type != 'Перетяжки')
      return rumonthes[online.databegin.month - 1]
    else
      return "#{daymonth(online.databegin).to_s} - #{daymonth(online.dataend).to_s}"
    end
  end
  
  def easybutton(txt,form,url,div='contacts')
    link_to_remote txt,
      :update => div,
      :url => url,
      :submit => form
  end

  def onlinelabel
    if (not session[:onlinepos].nil?) and session[:onlinepos] == 'online'
      label="Все поверхности"
      doit="all"
    else
      label="Online продажи"
      doit="online"
    end
    link_to_remote label,
      :update => 'online_div',
      :method => 'get',
      :before => "Element.show('spinner')", :success => "Element.hide('spinner')",
      :url => {:controller =>'online', :action => 'setonline', :onlinepos => doit}
  end
  
  def rumonthes
    ['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь']
  end
  
  def rlink(text, url, div='main_div')
    link_to_remote text, 
      :update => div,
      :before => "Element.show('spinner')", 
      :success => "Element.hide('spinner')", 
      :method => 'get', 
      :url => url
  end

  def loadinfo(p)
    @human = nil
    @icq = nil
    @email = nil
    @mob = nil
    @stac = nil
    @www = nil
    if params[:controller] == 'client' or params[:controller] == 'order'
      @human = Contact.find(:first, :conditions => {:client_id => p.id, :visible => 'true' }, :select=>'name, id')
      @human = Contact.find(:first, :conditions => {:client_id => p.id }, :select=>'name,id') if @human.nil?
    end

    if params[:controller] == 'contractor' or params[:controller] == 'banner'
      @human = Contact.find(:first, :conditions => {:contractor_id => p.id, :visible => 'true' }, :select=>'name, id')
      @human = Contact.find(:first, :conditions => {:contractor_id => p.id }, :select=>'name,id') if @human.nil?
    end

    if @human.nil?
      @human = Contact.new()
      @icq = Phone.new()
      @email = Phone.new()
      @stac = Phone.new()
      @mob = Phone.new()
      @www = Phone.new()

      @human.name = '-'
      @icq.number = '-'
      @email.number = '-'
      @stac.number = '-'
      @mob.number = '-'
      @www.number = '-'
    else
      #ids.each do |s|
      @icq = Phone.find(:first, :conditions =>{:tip => 'icq', :visible => 'true', :contact_id => @human.id})
      @email = Phone.find(:first, :conditions =>{:tip => 'e-mail', :visible => 'true', :contact_id => @human.id})
      @stac = Phone.find(:first, :conditions =>{:tip => 'гор', :visible => 'true', :contact_id => @human.id})
      @mob = Phone.find(:first, :conditions =>{:tip => 'моб', :visible => 'true', :contact_id => @human.id})
      @www = Phone.find(:first, :conditions =>{:tip => 'www', :visible => 'true', :contact_id => @human.id})
      #end
      if @icq.nil?
        @icq = Phone.find(:first, :conditions =>{:tip => 'icq', :contact_id => @human.id})
        if @icq.nil?
          @icq = Phone.new()
          @icq.number = '-'
        end
      end
      if @email.nil?
        @email = Phone.find(:first, :conditions =>{:tip => 'e-mail', :contact_id => @human.id})
        if @email.nil?
          @email = Phone.new()
          @email.number = '-'
        end
      end
      if @stac.nil?
        @stac = Phone.find(:first, :conditions =>{:tip => 'гор', :contact_id => @human.id})
        if @stac.nil?
          @stac = Phone.new()
          @stac.number = '-'
        end
      end
      if @mob.nil?
        @mob = Phone.find(:first, :conditions =>{:tip => 'моб', :contact_id => @human.id})
        if @mob.nil?
          @mob = Phone.new()
          @mob.number = '-'
        end
      end
      if @www.nil?
        @www = Phone.find(:first, :conditions =>{:tip => 'www', :contact_id => @human.id})
        if @www.nil?
          @www = Phone.new()
          @www.number = '-'
        end
      end
    end
    if params[:controller]!='contractor' and params[:controller]!='banner'
      p.orders.each do |ord|
        @contact = Time.now
      end
    end
  end

  def daymonth(data)
    ret=""
    ret+='0' if data.day.to_i < 10
    ret+=data.day.to_s
    ret+='.'
    ret+='0' if data.month.to_i < 10
    ret+=data.month.to_s
  end

  def howold(birthday)
    return 0 if birthday.nil?
    return (Date.today - birthday.to_date).to_i / 365
  end

  def rshow(text,id)
    rlink(text,{:action => 'show', :id => id.to_s})
  end

  def pricesize(p)
    ret =0
    Price.find(:all, :conditions => {:wtf =>p.wtf, :order_id => p.order_id, :coast =>p.coast}).each do |p|
      ret += p.size.to_i
    end
    return ret.to_s
  end
  
  def getprice(month, dek, coast)
    p = Price.find(:first, :conditions =>{:order_id => session[:order], :banner_id => params[:id], :month => month, :wtf => dek})
    if p.nil?
      return dek+" цена" if coast=='notreal'
      return dek+" себест" if coast=='real'
    else
      return p.realcoast if coast=='real'
      return p.coast if coast=='notreal'
    end
  end
  
  def calendarh(txt, cntrl, alt, date = Time.now, doing = 'r', orderid = '0', upddiv = 'xz', div = 'main_div')
    link_to_remote txt, 
      :update => div, 
      :before => "Element.show('spinner')", 
      :success => "Element.hide('spinner')", 
      :method => 'get', 
      :url => {
      :controller =>'office', 
      :action => "calendar", 
      :cntrl => cntrl, 
      :alt => alt, 
      :doing => doing, 
      :orderid => orderid,
      :upddiv => upddiv,
      :id => date.to_s
    }
  end

  def calendarhnext(txt, cntrl, alt, date = Time.now, doing = 'r', orderid = '0', upddiv = 'xz', div = 'main_div')
    link_to_remote txt,
      :update => 'calendarform',
      :before => "Element.show('spinner')",
      :success => "Element.hide('spinner')",
      :method => 'get',
      :url => {
      :controller =>'office',
      :action => "nextcalendar",
      :cntrl => cntrl,
      :alt => alt,
      :doing => doing,
      :orderid => orderid,
      :upddiv => upddiv,
      :id => date.to_s
    }
  end
  
  def adress(p, city=0)
    return '' if p.city.nil?
    result=' '
    result = p.city + ', ' if  (not p.city == 'Москва' and not p.city.nil?) or city==1
    if (not p.street.nil?) and p.street.size > 0
      result = result + p.street
      result = result + ' '+p.ulic if not p.ulic.nil? and p.street != 'МКАД' and p.street != 'ТТК'
    end
    result = result + " д."+p.house if (not p.house.nil?) and p.house.size != 0
    result = result + " ст."+p.stroen if (not p.stroen.nil?) and p.stroen.size != 0 
    result = result + " корпус "+p.korpus if (not p.korpus.nil?) and p.korpus.size != 0 
    result = result + " "+p.primech+" " if (not p.primech.nil?) and p.primech.size != 0
    return result
  end
  
  def upatrh(nm)
    observe_field(nm, 
      :frequency => 3,
      :url => { :controller =>'banner', :action => 'upatr', :id => @contractor.id, :name => nm, :cntrl =>'contractor' },
      :with => "'value=' + encodeURIComponent(value)")
  end
  
  def lnk(txt, id)
    link_to_remote txt, :update => 'main_div', :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'banner', :action => "show", :id => id}
  end
  
  def newdog(id)
    link_to_remote 'Добавить договор', :update => 'main_div', :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'office', :action => "newdogovor", :clientid => id}
  end
  
  def lnkc(txt, id)
    link_to_remote txt, :update => 'main_div', :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'contractor', :action => "show", :id => id}
  end
  
  def lnkcl(txt, id=params[:id], doing='order')
    if params[:do] == doing
      txt
    else
      link_to_remote txt, :update => 'main_div', :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'office', :action => "personal", :id => id, :do => doing}
    end
  end
  
  def deltel(id)
    if current_user.login == 'zm-admin'
      link_to_remote '[x]', :update => 'tel_div_'+id.to_s, :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'client', :action => "delphone", :id => id}, :confirm => "Точно удалить телефон?"
    end
  end
  
  def maintel(id)
    phone = Phone.find(id)
    if phone.visible=='false'
      link_to_remote imgdel, :update => 'maintel_div_'+id.to_s, :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'client', :action => "mainphone", :id => id, :doing => 'add'}
    else
      link_to_remote imgadd, :update => 'maintel_div_'+id.to_s, :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'client', :action => "mainphone", :id => id, :doing => 'del'}
    end
  end
  
  def imgadd
    image_tag("add.png")
  end
  
  def imgdel
    image_tag("del.png")
  end
  
  def imgremove
    #"<div id='imgremove'></div>"
    #image_tag("remove.png")
    "[x]"
  end
  
  def imgno
    image_tag("neworder.png")
  end
  
  def editcl(id)
    link_to_remote "[e]", :update => 'main_div', :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller=>'client', :action => "edit", :id => id}
  end

  def editdiv(txt,url)
    if current_user.login == 'zm-admin'
      link_to_remote txt, :update => 'main_div', :before => "Element.show('spinner')", :success => "Element.hide('spinner');", :method => 'get', :url => url
    end
  end
  
  def maincont(id)
    contact = Contact.find(id)
    if not contact.visible=='true'
      link_to_remote imgdel, :update => 'maincont_div_'+id.to_s, :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'client', :action => "maincont", :id => id, :doing => 'add'}
    else
      link_to_remote imgadd, :update => 'maincont_div_'+id.to_s, :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'client', :action => "maincont", :id => id, :doing => 'del'}
    end
  end
  
  def deldiv(cntrl, act, id, div, txt)
    if current_user.login == 'zm-admin'
      link_to_remote txt, :update => div, :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>cntrl, :action => act, :id => id}
    end
  end
  
  def deldivc(cntrl, act, id, div, txt, confirm)
    if current_user.login == 'zm-admin'
      link_to_remote txt, :update => div, :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>cntrl, :action => act, :id => id}, :confirm => "Точно удалить #{confirm}?"
    end
  end
  
  def ddiv(id)
    '<div id="del_div_'+id.to_s+'">'
  end
  
  def delcontact(id)
    if current_user.login == 'zm-admin'
      link_to_remote imgremove, :update => 'contactsmall_div_'+id.to_s, :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'client', :action => "delcontact", :id => id}, :confirm => "Точно удалить визитку?"
    end
  end
  
  def tip
    ['Перетяжки','3x6','3x6(призмавижн)','3x12','4x12','5x10','5x12','5x15','Арки','Брандмауэры','Крышные панели','Сетки','Экраны']
  end
  
  def spiner
    image_tag("spinner.gif",
      :align => "absmiddle",
      :border => 0,
      :id => "spinner",
      :size => "12x12",
      :class => "loader",
      :style =>"display: none;" )
  end
  
  def helporder(txt, id)
    link_to_remote txt.to_s, :update => 'main_div', :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller => 'order', :action => "help", :id => id}
  end
  
  def coastx(id)
    ret=0
    order = Order.find(id)
    order.prices.each do |p|
      ret += p.coast.to_i
      #ret += 1
    end
    ret
  end
  
  def realcoast(id)
    ret=0
    order = Order.find(id)
    order.prices.each do |p|
      ret += p.realcoast.to_i
    end
    ret
  end
end
