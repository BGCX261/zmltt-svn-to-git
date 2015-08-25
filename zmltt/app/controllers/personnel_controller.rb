class PersonnelController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required
  def personnel
  end
  
  def index
    @users = User.not_archived
  end

  def arch
    @users = User.archived
    render :template => 'personnel/index'
  end
  
  def show
    @user = User.find(params[:id])
    render(:layout => 'main') if request.xhr?
  end
  
  def edit
    @user = User.find(params[:id])
    if request.post? and @user.update_attributes(params[:user])
      redirect_to :action => 'index'
    else
      render(:layout => 'main') if request.xhr? or params[:xhr]
    end
  end

  def to_arch
    user = User.find(params[:id])
    if user.archived == 'Нет'
      user.update_attribute(:archived, 'Да')
    else
      #user.update_attribute(:archived, 'Нет')
      User.delete(params[:id])
    end
    render :partial => "app/deldiv", :locals => { :div => "deluser_div_"+params[:id]}
  end
end
