# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  Time::DATE_FORMATS[:rusdate] = '%Y-%m-%d'
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '5a9c74323646a10e9bb16fce740f2e48'
  
  private
  def share_xml(object, method, options = {})
    find_options = { 
      :conditions => [ "LOWER(#{method}) LIKE ?", '%' ], 
      :order => "#{method} ASC",
      :select => "DISTINCT #{method}",
      :limit => 100 }.merge!(options)
    items = Array.new()
    object.to_s.camelize.constantize.find(:all, find_options).each do |o|
      items += [o[method]];
    end
    return items
    #render :text => @items.to_xml#"<%= auto_complete_result @items, '#{method}' %>"
  end
    
  def cart
    @client = Client.find(:first, :conditions => {:id => session[:client]})
    @order = Order.find(:first, :conditions => {:id => session[:order]})
    #msv=Array.new()
    #msv=session[:ids] if not (session[:ids].nil?)
    if not params[:id].nil?
      @banner = Banner.find(params[:id])
      if params[:do]=="del"
        prices = Price.find(:all, :conditions => {:order_id =>session[:order], :banner_id =>params[:id]} )
        prices.each do |p|
          Price.delete(p.id)
        end
        @do = "add"
      end
      render :layout=>false
    else
      @price = Price.find(:all, :conditions => {:order_id =>session[:order]})
      msv=Array.new()
      @monthdek=Hash.new()
      @bannermonthes = Array.new()
      @price.each do |p|
        msv[msv.size] = p.banner_id if not p.banner_id.nil?
        if p.wtf =~ /\d/ and not p.month.nil?
          @monthdek[p.banner_id.to_s+p.month+p.wtf] = p.coast
          @bannermonthes += [p.month]
        end
        msv.uniq!
        #@bannermonthes.uniq!
        sorted_monthes = {'Январь' => 1, 'Февраль' => 2,'Март' => 3, 'Апрель' => 4,'Май' => 5,'Июнь' => 6,'Июль' => 7,'Август' => 8,'Сентябрь' => 9,'Октябрь' => 10,'Ноябрь' => 11,'Декабрь' => 12}
        @bannermonthes = @bannermonthes.uniq.sort_by {|m| sorted_monthes[m]}
      end
      @banner=Array.new()
      @peret=Array.new()
      if not (msv == [])
        msv.each do |m|
          tmp = Banner.find(m)
          if tmp.tp != 'Перетяжки'
            @banner[@banner.size] = tmp
          else
            @peret[@peret.size] = tmp
          end
          #@dopusl = Price.dopusl(m,session[:order])
          #@dopusl = Price.find(:all, :conditions => {:banner_id => m, :order_id => session[:order]})
          #@dopusl.each do |d|
          #  @banner[@banner.size - 1].zametka = @banner[@banner.size - 1].zametka + ' [' + d.wtf+']' if not d.extra_id.nil?
          #end
        end
      end
      #render(:layout => 'main') if request.xhr?
    end
  end

  def findbanners
    session[:tip] = ["0"] if session[:tip].nil?
    session[:spodr] = ["0"] if session[:spodr].nil?
    session[:onlinepos] = 'all' if session[:onlinepos].nil?
    session[:city] = "Москва" if Banner.find(:all,:conditions => [ 'city LIKE ?',session[:city]]).size == 0
    #session[:city].nil? or session[:city].size < 2 or session[:city] == "Москва и направления"

    #params[:search] = session[:search] if not session[:search].nil?
    params[:search] = '' if params[:search].nil? or params[:search].size < 1
    params[:search] = $1 if params[:search]=~/(\S+)\s(.*)/
    
    session[:later] = params[:search]
    session[:search] = params[:search]
    #if (session[:search].nil? or session[:search].size < 1)
    #  session[:later] = '1'
    #  session[:search] = '1'
    #end
    @banner = fbanner()
    tmp = @banner.size
    #if @banner.size > 1300 and session[:later].size > 2
    #  @banner = nil
    #  @banner = Array.new
    #  @banner[0] = Banner.new()
    #  @banner[0].id = 0
    #  @banner[0].city = "Очень много соответствий(#{tmp.to_s+'-'+session[:tip].to_s+'-'+session[:onlinepos]+'-'+session[:city]+'-'+session[:search]}). Уточните запрос"
    #end
    session[:city]='Москва и направления' if session[:city]=='Москва'
  end

  def fbanner
    cc=Contractor.new()
    cc.name="нет"
    b=Banner.find(:all,:conditions => [ 'street LIKE ? AND city LIKE ?',session[:search] + '%', session[:city]], :order=> "street").find_all{ |elem| ((not session[:tip].include?(elem.tp)) and (not session[:spodr].include?((elem.contractor||cc).name))) }
    b = b.find_all{|elem| elem.online=="есть"} if session[:onlinepos] == 'online'
    b.sort_by {|model| [model.street, model.house.to_i]}
  end

  def hidecontractors
    session[:spodr] = ["0"]
    session[:showall]='нет'
    cc = Contractor.find(:all, :select => 'name')
    cc.each do |p|
      session[:spodr] += [p.name]
    end
  end

  def showcontractors
    session[:showall]='да'
    session[:spodr] = nil
  end

  def findcontractors
    podrs = Contractor.find(:all, :order=> "name", :select => 'name, otrasl')
    @podr=Array.new()
    podrs.each do |p|
      #if p.otrasl == 'Наружная реклама'
      #не отображать подрядчиков не из наружки
      @podr[@podr.size] = p.name if p.name
      #  else
      #    session[:spodr] += [p.name] if p.name
      #end
    end
    @podr.uniq!
  end

  def showalltips
    session[:showalltips] = 'да'
    session[:tip] = nil
  end

  def hidealltips
    session[:showalltips] = 'нет'
    session[:tip] = tips
  end

  def tips
    ['Перетяжки','3x6','3x6(призмавижн)','5x10','4x12','3x12','5x12','5x15','Арки','Брандмауэры','Крышные панели','Сетки','Экраны']
  end

  def clearorders
    #client = Client.find(:first, :conditions => {:name => 'Не зарегистрированный'})
    time = Time.now - 72.hour
    Order.find(:all).each do |ord|
      Order.delete(ord.id) if ord.prices.size == 0 and ord.updated_at < time and ord.status != 'connector' and (ord.order.nil? or ord.order.size > 10)
    end
    #Order.delete_all("user_id='0' and client_id='#{client.id.to_s}' and status='открыт' and updated_at < '#{time.to_s(:db)}'")
  end
end
