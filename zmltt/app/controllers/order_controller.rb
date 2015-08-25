class OrderController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required, :except => [:update, :new, :enter, :client, :help, :setextra, :delorder, :add2rec, :erasefree]
  in_place_edit_for :client, :zametka
  in_place_edit_for :order, :status
  in_place_edit_for :order, :order
  
  def enter
    if logged_in?
      redirect_to :action=>'status'
    else
      if session[:client].nil? or session[:client] == Client.find(:first, :conditions => {:name => 'Не зарегистрированный'}).id.to_s
        redirect_to :action=>'status'
      else
        redirect_to :action=>'client'
      end
    end
  end

  def update
    @order = Order.find(session[:order])
    value = params[:order][:order] if params[:order]
    @order.update_attribute(params[:name],value)
    render :text => params[:name]+value
  end

  def status
    usr = Array.new()
    params[:id] = Time.now.to_date if params[:id].nil?
    if current_user.cfg == 'client'
      Order.find(:all, :conditions =>['user_id = ? and contact <= ?', current_user.id, params[:id].to_date ],:select=>'client_id').each do |p|
        usr[usr.size]=p.client_id if Client.exists?(p.client_id)
      end
      @clients = Client.find(usr)
      shortdate = Date.new
      shortdate = params[:id].to_date || Time.now.to_date
      @clients.each do |p|
        p.orders.each do |ord|
          shortdate = ord.contact if shortdate > ord.contact
        end
        p.contact = shortdate
      end
    else
      @orders = Order.find(:all, :conditions =>['user_id = ? and contact <= ?', current_user.id, params[:id].to_date ])
    end
    render :layout => false if request.xhr? or params[:xhr]
  end

  def new
    params[:id]=session[:client] if not logged_in?
    @order = Order.new();
    @order.order = params[:order][:order] if params[:order]
    @order.client_id = params[:id]
    @order.status = "открыт"
    @order.user_id = current_user.id if logged_in?
    @order.save
    session[:order] = @order.id.to_s
    session[:client] = params[:id]
    #render(:layout => 'main') if request.xhr?
    if params[:rdrct]
      @order.update_attribute('status','connector')
      redirect_to :controller=>'client', :action => 'edit', :id => params[:id], :xhr => params[:xhr]
    else
      redirect_to :controller => 'banner', :action => 'recycler'
    end
    
  end
  
  def menager
    @orders = Order.find(:all, :conditions => {:user_id => current_user.id})
  end
  
  def client
    @orders = Order.find(:all, :conditions => {:client_id => session[:client]})
  end
  
  def control
    order = Order.find(params[:id])
    order.update_attribute('user_id',current_user.id)
    session[:order] = params[:id]
    session[:client] = order.client_id
    redirect_to :controller => 'banner', :action => 'recycler'
  end
  
  def help
    order = Order.find(params[:id])
    session[:order] = params[:id]
    session[:client] = order.client_id
    redirect_to :controller => 'banner', :action => 'recycler'
  end
  
  def setextra
    @extra = Extra.find(:all)
    render(:layout => 'main') if request.xhr?
  end
  
  def listextra
    @extra = Extra.find(:all)
    render(:layout => 'main') if request.xhr?
  end
  
  def addextra
    @extra = Extra.new(params[:extra])
    if request.post? and @extra.save
      #flash[:notice] = @extra.name+': новая дополнительная услуга создана'
      redirect_to :action => 'listextra'
    else
      render(:layout => 'main') if request.xhr?
    end
  end
  
  def delextra
    Extra.delete(params[:id])
    render :partial => "app/deldiv", :locals => { :div => "delex_div_"+params[:id]}
  end
  
  def editextra
    @extra = Extra.find(params[:id])
    if request.post? and @extra.update_attributes(params[:extra])
      #flash[:notice] = @extra.name+': изменения сохранены.'
      redirect_to :action => 'index'
    else
      render(:layout => 'main') if request.xhr?
    end  
  end
  
  def add2rec
    extra = Extra.find(params[:id]) if params[:id]
    extra = Extra.find(:first, :conditions => {:name => params[:makes]}) if params[:makes]
    if extra.nil?
      extra = Extra.find(:first, :conditions => {:name => "По умолчанию"})
    end
    #order = Order.find(session[:order])
    price = Price.new
    Price.find(:all, :conditions =>{:order_id => session[:order], :banner_id => params[:bannerid], :month => params[:month]}).each do |p|
      price = p if not p.extra_id.nil?
    end
    param = Hash.new
    param[:banner_id] = params[:bannerid] if params[:bannerid]
    param[:extra_id] = extra.id
    param[:coast] = extra.coast
    param[:realcoast] = extra.realcoast
    param[:wtf] = extra.name
    param[:month] = params[:month] if params[:month]
    param[:order_id] = session[:order]
    if price.nil?
      param[:size]='1'
      price = Price.new(param) 
      price.save
    else
      price.update_attributes(param)
      Price.delete(price.id) if params[:makes] == 'нет'
    end
    #render :text => tmp
    redirect_to :controller => 'banner', :action => 'recycler'
  end
  
  def erasefree
    Price.delete(params[:id])
    #redirect_to :controller => 'banner', :action => 'recycler'
    #render :text => '1'
    render :partial => "app/deldiv", :locals => { :div => "delexfree_div_"+params[:id]}
  end
  
  def freeextra
    @price = Price.new(params[:price])
    @price.order_id = session[:order]
    @price.size = '1'
    @price.extra_id = 29051987
    if request.post? and @price.save
      redirect_to :controller => 'banner', :action => 'recycler'
    else
      render(:layout => 'main') if request.xhr?
    end
  end
  
  def index
    @orders = Order.find(:all)
  end
  
  def delorder
    Order.delete(params[:id])
    render :partial => "app/deldiv", :locals => { :div => "delord_div_"+params[:id]}
  end
  
  def order
  end
end
