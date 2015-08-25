$KCODE = 'u'
require 'jcode'
class BannerController < ApplicationController
  protect_from_forgery :except => [:livesearch,:cart,:flex, :edit, :addphoto]
  include AuthenticatedSystem
  before_filter :login_from_cookie
  #before_filter :login_required, :except => [:fademain, :set_price_size, :show, :index, :file_id, :livesearch, :recycler, :tip, :showall] 
  before_filter :login_required, :only => [:add, :edit, :del, :upatr] 
  skip_before_filter :verify_authenticity_token, :only => [:flex, :auto_complete_for_banner_city, :auto_complete_for_banner_street]
  auto_complete_for :banner, :city
  auto_complete_for :banner, :street
  in_place_edit_for :price, :wtf
  in_place_edit_for :price, :coast
  in_place_edit_for :price, :size
  in_place_edit_for :price, :databegin
  in_place_edit_for :price, :dataend

  def share_xml
    #@items = share_xml('banner','street');
    render :text=> share_xml('banner',params[:format])
  end
  
  def secret
    #----------------Удаление балванок------------------------------------
    banners = Banner.find(:all, :conditions =>{:street => nil})
    banners.each do |b|
      Banner.delete(b.id)
    end
	
    banners = Banner.find(:all, :conditions =>{:city => nil})
    banners.each do |b|
      Banner.delete(b.id)
    end
    #----------------------------------------------------
    #onls = Online.find(:all)
    #onls.each do |online|
    #  online.coast = (online.coast.to_i/100).to_s;
    #  online.coast = (online.coast.to_i*100).to_s;
    #  online.save!
    #end
    #@order = Order.new();
    #@order.client_id = 26
    #@order.status = "connector"
    #@order.user_id = 1
    #@order.save
    render :text => banners.size
  end

  def flex
    return 'no search string' if params[:search].to_s.length < 1
    if session[:order].nil? or session[:order].size < 1 or not Order.exists?(session[:order])
      client = Client.find(:first, :conditions => {:name => 'Не зарегистрированный'})
      order = Order.new()
      order.client_id = client.id
      order.status = "открыт"
      order.user_id = '0'
      order.save
      session[:order] = order.id.to_s
      session[:client] = client.id.to_s
      clearorders()
    end
    params[:search] = "мкад" if params[:id]=='web'
    params[:city] = "Москва и направления" if params[:id]=='web'
    session[:onlinepos] = params[:onlinepos] if not params[:onlinepos].nil? and params[:onlinepos].size > 2

    session[:tip]=['0']
    session[:tip] = params[:type].split(';') if params[:type]
    session[:spodr] = params[:podr].split(';') if params[:podr]
    session[:tip].insert(-1, '3x6(призмавижн)') if params[:type] and params[:type].include?('3x6')
    session[:search] = params[:search]
    session[:city] = params[:city]
    if params[:search] and params[:search]=~/(\d+)\.(.*)/
      contractor = Contractor.find(:first, :conditions => {:nid => $1})
      @banner = Banner.find(:all,:conditions =>['xnomer LIKE ? AND contractor_id LIKE ?',$2+'%', contractor.id])
    else
      findbanners()
    end
    i=0
    @banner.each do |p|
      result=' '
      result = p.city + ', ' if  (not p.city == 'Москва' and not p.city.nil?)
      if (not p.street.nil?) and p.street.size > 0
        result = result + p.street
        result = result + ' '+p.ulic if not p.ulic.nil? and p.street != 'МКАД' and p.street != 'ТТК'
      end
      result = result + " д."+p.house if (not p.house.nil?) and p.house.size != 0
      result = result + " ст."+p.stroen if (not p.stroen.nil?) and p.stroen.size != 0
      result = result + " корпус "+p.korpus if (not p.korpus.nil?) and p.korpus.size != 0
      result = result + " "+p.primech+" " if (not p.primech.nil?) and p.primech.size != 0
      p.city = result
      #p.price = String.new('3456')
    end
    render :layout => false #render :text => @banner.to_xml
  end

  def cart
    @client = Client.find(:first, :conditions => {:id => session[:client]})
    @order = Order.find(:first, :conditions => {:id => session[:order]})
    msv=Array.new()
    msv=params[:ids].split(';')
    @banner = Banner.find(msv)
    #    render :text => @banner.to_xml
    #    msv.
    #    if not params[:id].nil?
    #      @banner = Banner.find(params[:id])
    #      if params[:do]=="del"
    #        prices = Price.find(:all, :conditions => {:order_id =>session[:order], :banner_id =>params[:id]} )
    #        prices.each do |p|
    #          Price.delete(p.id)
    #        end
    #        @do = "add"
    #      end
    #      render :layout=>false
    #    else
    #      @price = Price.find(:all, :conditions => {:order_id =>session[:order]})
    #      msv=Array.new()
    #      @monthdek=Hash.new()
    #      @bannermonthes = Array.new()
    #      @price.each do |p|
    #        msv[msv.size] = p.banner_id if not p.banner_id.nil?
    #        if p.wtf =~ /\d/ and not p.month.nil?
    #          @monthdek[p.banner_id.to_s+p.month+p.wtf] = p.coast
    #          @bannermonthes += [p.month]
    #        end
    #        msv.uniq!
    #        #@bannermonthes.uniq!
    #        sorted_monthes = {'Январь' => 1, 'Февраль' => 2,'Март' => 3, 'Апрель' => 4,'Май' => 5,'Июнь' => 6,'Июль' => 7,'Август' => 8,'Сентябрь' => 9,'Октябрь' => 10,'Ноябрь' => 11,'Декабрь' => 12}
    #        @bannermonthes = @bannermonthes.uniq.sort_by {|m| sorted_monthes[m]}
    #      end
    #      @banner=Array.new()
    #      @peret=Array.new()
    #      if not (msv == [])
    #        msv.each do |m|
    #          tmp = Banner.find(m)
    #          if tmp.tp != 'Перетяжки'
    #            @banner[@banner.size] = tmp
    #          else
    #            @peret[@peret.size] = tmp
    #          end
    #          #@dopusl = Price.dopusl(m,session[:order])
    #          #@dopusl = Price.find(:all, :conditions => {:banner_id => m, :order_id => session[:order]})
    #          #@dopusl.each do |d|
    #          #  @banner[@banner.size - 1].zametka = @banner[@banner.size - 1].zametka + ' [' + d.wtf+']' if not d.extra_id.nil?
    #          #end
    #        end
    #      end
    #      #render(:layout => 'main') if request.xhr?
    #    end
  end

  def supersite
    banners = Array.new()
    ['Перетяжки','Арки','Брандмауэры','Крышные панели','Сетки','Экраны'].each do |tipi|
      banners = Banner.find(:all, :conditions => {:tp =>tipi.downcase})
      banners.each do |b|
        b.update_attribute(:tp, tipi)
      end
    end
    render :text => banners.size.to_s
  end
  
  def showall
    if params[:id] == 'tip'
      showalltips if params[:do] == 'all'
      hidealltips if params[:do] == 'notall'
    else
      showcontractors if params[:do] == 'all'
      hidecontractors if params[:do] == 'notall'
    end
    redirect_to :action => 'index'
  end
  
  def index
    hidealltips if session[:showalltips].nil?
    #session[:later]= params[:later] if params[:later]  
    params[:search] = session[:search] if session[:search]
    findcontractors
    if session[:order].nil? or session[:order].size < 1 or not Order.exists?(session[:order])
      client = Client.find(:first, :conditions => {:name => 'Не зарегистрированный'})
      order = Order.new()
      order.client_id = client.id
      order.status = "открыт"
      order.user_id = '0'
      order.save
      session[:order] = order.id.to_s
      session[:client] = client.id.to_s
      clearorders()
    end

    findbanners()
    city = Banner.find(:all, :order=> "city, street, house")
    @citys=Array.new()
    #@citys=['Москва']
    city.each do |p|
      @citys += [p.city]
    end
    @citys=@citys.compact.uniq!
    @citys -= ['Москва','Ба']
    @citys = ['Москва и направления']+@citys
    @citys = @citys - [session[:city]]
  end
  
  def cities
    city = Banner.find(:all, :order=> "city, street, house")
    @citys=Array.new()
    #@citys=['Москва']
    city.each do |p|
      @citys += [p.city]
    end
    @citys=@citys.compact.uniq!
    @citys -= ['Москва','Ба']
    @citys = ['Москва и направления']+@citys
    findcontractors()
    #render :text => @citys
    #render :text => params[:city]
  end
  
  def upatr
    if params[:name] =~ /banner_(.+)/
      params[:name] = $1
    end
    if params[:cntrl]=='contractor'
      @banner = Contractor.find(params[:id])
    else
      @banner = Banner.find(params[:id])
    end
    @banner.update_attribute(params[:name], params[:value])
    render :text => '1'
  end
  
  def livesearch
    showalltips if session[:showalltips]=='нет'
    session[:search] = nil if session[:search] and session[:search] == "%%"
    if params[:later]
      session[:later]= params[:later]
      #params[:search] = params[:later]
      session[:search] = params[:later]
      redirect_to :action => 'index'
    else
      if params[:city]
        session[:city] = params[:city]
        if params[:city]=='Москва и направления'
          params[:search] = '1'
          params[:later] = '1'
          session[:search] = '1'
          session[:later] = '1'
          #session[:city] = 'Москва'
        else
          params[:search] = '%%'
        end
      end
      if defined?(params[:search]) and (not  params[:search].nil?) and params[:search].jsize == 0
        params[:search]=nil
      end
      if (session[:later]!=session[:search]) and (params[:search].nil? or params[:search].jsize < 2) and (request.xhr? or params[:xhr])
        session[:search]=nil
        render :text => '<center><b>Для поиска необходимо ввести более 2-х символов</b></center>'
      else
        if params[:search] and params[:search]=~/(\d+)\.(.*)/
          contractor = Contractor.find(:first, :conditions => {:nid => $1})
          @banner = Banner.find(:all,:conditions =>['xnomer LIKE ? AND contractor_id LIKE ?',$2+'%', contractor.id])
        else
          findbanners()
        end
        render :layout=>false
      end
    end
  end
  
  def add
    if current_user.login == 'zm-admin'
      #debug params[:banner]
      @banner=Banner.new()
      @banner.ulic = 'ул.'
      @banner.light = 'есть'
      @banner.storona = 'A'
      @banner.tp = 'Перетяжки'
      #@banner.contractor_id = Contractor.find(:first).id
      @banner.save!
      @photo = Array.new()
      #@contractors = Contractor.find(:all)
      #if request.post? and @banner.save
      #  flash[:notice] = 'Новый объект создан. Добавьте фотографий.'
      #render :text => @banner.id
      #redirect_to :action => 'edit', :id=>@banner.id#, :xhr => '1'
      render :action => 'show'
      #else
      #  render(:layout => 'main') if request.xhr?
      #end
    else
      render :text => 'Надо войти'
    end
  end
  
  def edit
    if current_user.login == 'zm-admin'
      @contractors = Contractor.find(:all)
      
      @banner = Banner.find(params[:id])
      @photo = @banner.photos if not @banner.nil?
      
      if request.post?
        contr = Contractor.find(:first, :conditions => {:name => params[:banner][:contractor_id]}) if(params[:banner] and params[:banner][:contractor_id].to_s.length > 1)
        params[:banner][:contractor_id] = contr.id.to_s if not contr.nil?
        if @banner.nil?
          @banner = Banner.new(params[:banner])
          @banner.save!
        else
          @banner.update_attributes(params[:banner]) 
        end
        render :text => 'ok'
      end
    else
      render :text => 'Надо войти'
    end
  end
  
  def show
    @banner = Banner.find(params[:id])
    @photo = @banner.photos(:order => "id ASC")
    #render :text => @banner.to_xml + @photo.to_xml
    #render :layout => false if params[:format]=='xml'
    #render :layout => 'main' if params[:format]!='xml'
    redirect_to("http://zimaletto.su/show/#id="+params[:id]) if params[:format]!='xml'
  end
  
  def del
    if current_user.login == 'zm-admin'
      Banner.delete(params[:id])
      #flash[:notice] = "Объект удален"
      #render :partial => "app/deldiv", :locals => { :div => "delban_div_"+params[:id]}
      #redirect_to :action => 'index'
      render :text => 'Поверхность удалена'
    end
  end
  
  def delphoto
    if current_user.login == 'zm-admin'
      #ss=Photo.find(params[:id]).banner_id
      Photo.delete(params[:id])
      #flash[:notice] = "Объект удален"
    end
    render :text => 'ok'
  end
  
  def file_id
    @photo = Photo.find(params[:id])
    send_data @photo.db_file.data, :type => @photo.content_type, :filename => @photo.filename, :disposition => 'inline'
  end

  def iframe
    @banner = Banner.find(params[:id]) if params[:ctrl]=='banner'
    @banner = User.find(params[:id]) if params[:ctrl]=='user'
    @banner = Promo.find(params[:id]) if params[:ctrl]=='promo'
    @photo = @banner.photos
    render :layout=>false 
  end
  
  def addphoto
    #if current_user.login == 'zm-admin'
      @photo=Photo.new(params[:photo])
      @photo.banner_id=params[:banner_id][:id] if params[:banner_id]
      @photo.promo_id=params[:promo_id][:id] if params[:promo_id]
      @photo.user_id=params[:user_id][:id] if params[:user_id]
      #@photo.rewind
      #render :layout=>false
      if request.post?
        @photo.save!
        #render :layout=>false
        #redirect_to :controller => 'banner', :action => 'iframe', :ctrl => params[:ctrl], :id => params[:id]
        render :text => @photo.id.to_s#, :status => 200
      else
        render :text => '', :status => 200
        #render :text => ''
      end
    #end
  end
  
  def recycler
    cart
  end
  
  def tip 
    msv=Array.new()
    msv=session[:tip] if not (session[:tip].nil?)
    session[:showalltips]='хз'
    if params[:do]=="del"
      msv[msv.size] = params[:tip]
      msv[msv.size] ='3x6(призмавижн)' if params[:tip]=='3x6'
      msv=msv.uniq.compact.sort
      session[:tip] = msv
    else
      msv=msv-[params[:tip]]
      msv=msv-['3x6(призмавижн)'] if params[:tip]=='3x6'
      session[:tip] = msv
    end
    session[:search] = '1' if session[:search].nil? or session[:search].size < 1
    params[:search] = session[:search]
    if session[:search]=='1' and not msv.include?('3x6') and not msv.include?('Перетяжки')
      #session[:search] = "%%"
    else
      #render :text => msv
    end
    findbanners()
    render :layout=>false
  end
  
  def tippodr
    msv=Array.new()
    msv=session[:spodr] if not (session[:spodr].nil?)

    if params[:do]=="del"
      msv[msv.size] = params[:spodr]
      msv=msv.uniq.compact.sort
    else
      msv=msv-[params[:spodr]]
    end
    session[:spodr] = msv
    if session[:search].nil?
      @banner = Banner.find(:all).find_all{ |elem| not session[:spodr].include?(elem.contractor.name) }
    else
      params[:search] = session[:search]
      findbanners()
    end
    render :layout=>false 
  end
  

end
