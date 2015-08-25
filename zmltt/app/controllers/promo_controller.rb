class PromoController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required
  auto_complete_for :promo, :city
  auto_complete_for :promo, :color
  auto_complete_for :promo, :metro
  auto_complete_for :promo, :livepoint
  def promo
  end

  def index
    @promos = Promo.find(:all)
    #render(:layout => 'main') if request.xhr?
  end

  def add
    @promo = Promo.new(params[:promo])
    if request.post? and @promo.save
      redirect_to :action => 'index'
    else
      render(:layout => 'main') if request.xhr?
    end
  end

  def edit
    @promo = Promo.find(params[:id])
    if request.post? and @promo.update_attributes(params[:promo])
      #flash[:notice] = 'Изменения сохранены'
      redirect_to :action => 'index'
    else
      render(:layout => 'main') if request.xhr? or params[:xhr]
    end
  end

  def show
    @promo = Promo.find(params[:id])
    render(:layout => 'main') if request.xhr?
  end

  def del
    Promo.delete(params[:id])
    render :partial => "app/deldiv", :locals => { :div => "delpromo_div_"+params[:id]}
  end

  def filtr
    if params[:otdel]=="все"
      @promos = Promo.find(:all)
    else
      @promos = Promo.find(:all,:conditions =>{:otdel => params[:otdel]})
    end
    render(:layout => false)
  end
end
