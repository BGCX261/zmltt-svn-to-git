class OfficeController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  #before_filter :login_required, :except => [:addnotregister]
  in_place_edit_for :order, :status
  in_place_edit_for :client, :login
  in_place_edit_for :client, :password
  in_place_edit_for :client, :gendir
  in_place_edit_for :client, :bux
  
  def office
  end

  def recycler
    cart
  end

  def set_price_dek
    price = Price.find(:first, :conditions =>{:order_id => session[:order], :banner_id => params[:id], :month => params[:month], :wtf => params[:dek]})
    if price.nil?
      price = Price.new() 
      price.order_id = session[:order]
      price.banner_id = params[:id]
      price.month = params[:month]
      price.wtf = params[:dek]
      price.save!
    end
    price.update_attribute(params[:coast], params[:value])
    render :text=>params[:value]
  end
  
  def showperet
    
    render(:layout => 'main') if request.xhr?
  end
  
  def addprice
    banner = Banner.find(params[:id])
    @price = Price.new()
    @price.order_id = session[:order]
    @price.banner_id = params[:id]
    if banner.online == "есть"
      online = banner.onlines.first
      @price.coast = online.coast
      @price.realcoast = online.realcoast
      @price.databegin = online.databegin
      @price.dataend = online.dataend
    else
      
      
    end
    @price.save!
    render(:layout => 'main') if request.xhr?
  end

  def feedback
    if request.post? or params[:format]=='xml'
      @order = Order.find(session[:order])
      value = params[:email] + "\n" + params[:subj] if params[:subj]
      @order.update_attribute('order',value)
      #redirect_to :controller => 'banner', :action => 'index'
      render :text => 'ok'
    else
      #render(:layout => 'main') if request.xhr?
      render :text => 'error'
    end
  end

  def setcontact
    render :layout=>false 
    if current_user.cfg == 'client'
      
      Order.find(:all, :conditions =>['contact <= ?', Time.now.to_date ]).each do |p|
        p.update_attribute('contact',Time.now.to_date)
      end

      Order.find(:all, :conditions =>{:contact => params[:lastdate].to_date, :client_id => params[:orderid] }).each do |p|
        p.update_attribute('contact',params[:id].to_date)
      end

    else
      Order.find(:first, :conditions =>{:id => params[:orderid]}).update_attribute('contact',params[:id].to_date)
    end
  end
  
  def showphoto
    render(:layout => 'photo') if request.xhr?
  end
  
  def setrecycler
    render :layout=>false
    Price.find(:first, :conditions =>{:id => params[:orderid]}).update_attribute('databegin', params[:id].to_date)
  end
  
  def setrecyclerend
    render :layout=>false
    Price.find(:first, :conditions =>{:id => params[:orderid]}).update_attribute('dataend', params[:id].to_date)
  end
  
  def calendar
    render(:layout => 'main') if request.xhr?
  end

  def nextcalendar
    render(:layout => false)
  end
  
  def calendar_use
    if params[:doing]=='r'
      redirect_to :controller =>params[:cntrl], :action =>params[:alt], :id => params[:id]
    end
    if params[:doing]=='s'
      redirect_to :controller =>params[:cntrl], :action =>params[:alt], :id => params[:id], :orderid => params[:orderid], :lastdate =>params[:lastdate], :upddiv => params[:upddiv]
    end
  end
  
  def cfg
    current_user.cfg=params[:statusv] if params[:statusv]
    current_user.save
    redirect_to :controller => 'order', :action => 'status'
  end
  
  def newdogovor
    params[:clientid]
    @ourfirms = Client.find(:all)
    @clients = ([Client.find(params[:clientid])] + Client.find(:all)).uniq
    @dogovor=Dogovor.new(params[:dogovor])
    @dogovor.status = 'только создан'
    if request.post? and @dogovor.save
      #flash[:notice] = 'Новый договор добавлен'
      redirect_to :action => 'personal', :doing=>'contract', :id => params[:clientid][:id]
    else
      render(:layout => 'main') if request.xhr?
    end
  end
  
  def personal
    @client = Client.find(params[:id])
    params[:do] = params[:doing] if params[:doing]
    if params[:do]=='order'
      @orders = @client.orders
    end
    if params[:do]=='about'
      
    end
    if params[:do]=='contract'
      @dogovors = Dogovor.find(:all)
    end
    if params[:do]=='phone'
      
    end
    render(:layout => 'main') if request.xhr?
  end
end
