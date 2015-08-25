class AccountController < ApplicationController
  protect_from_forgery :except => [:login]
  include AuthenticatedSystem
  before_filter :login_from_cookie

  def index

  end

  def login
    unless (request.post? or params[:format]=='xml') and params[:login].size > 2
      render(:layout => 'main') if request.xhr?
      return
    end
    client = Client.find(:first, :conditions => {:login => params[:login], :password => params[:password]})
    if client.nil?
      self.current_user = User.authenticate(params[:login], params[:password])
      if logged_in?
        #if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
        #end
        #Order.delete(session[:order]) if session[:order]
        if(params[:format]!='xml')
          redirect_to(:controller => '/banner', :action => 'index')
          flash[:notice] = "Вы вошли как "+current_user.fio
        else
          @user = User.new();
          @user = current_user;
          @right = 'manager'
          @right = 'admin' if current_user.login=='zm-admin'# or current_user.login=='cavernxxx'
          render :layout=>false #:text => current_user.to_xml
        end
      else
        render :text => 'error' if params[:format]=='xml'
      end
    else
      if(params[:format]!='xml')
        session[:client] = client.id
        #Order.find(session[:order]) if session[:order]
        flash[:notice] = "Вы вошли как "+client.name
        redirect_to :controller => 'order', :action => 'client', :id => client.id
      else
        @user = User.new();
        @user.fio = client.name
        @right = 'client'
        render :layout=>false #:text => user.to_xml
      end
    end
  end

  def whoami
    if logged_in?
      @user = current_user;
      @right = 'manager'
      @right = 'admin' if current_user.login=='zm-admin'
      render :action => 'login'
    else
      render :text => 'error'
    end
  end
  
  def signup
    @user = User.new(params[:user])
    unless request.post?
      render(:layout => 'main') if request.xhr?
      return
    end
    @user.save!
    #self.current_user = @user
    redirect_back_or_default(:controller => '/personnel', :action => 'index')
    flash[:notice] = @user.fio+" добавлен!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    #flash[:notice] = "Выход выполнен"
    #redirect_back_or_default(:controller => 'banner', :action => 'index')
    render :text => 'ok'
  end
end
