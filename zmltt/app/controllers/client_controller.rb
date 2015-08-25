require "rubygems"

class ClientController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required
  in_place_edit_for :contact, :name
  in_place_edit_for :contact, :post
  in_place_edit_for :phone, :number
  in_place_edit_for :rekvizit, :gendir
  in_place_edit_for :rekvizit, :bux
  in_place_edit_for :rekvizit, :gendirosn
  
  def index
    @clients = Client.find(:all)
    #render(:layout => 'main') if request.xhr?
  end
  
  def tests
    render :text => params
  end
  
  def add
    @client = Client.new(params[:client])
    @client.save
    @rekvizit = Rekvizit.new()
    @rekvizit.client_id = @client.id
    @rekvizit.save
    redirect_to :controller=>'order', :action => 'new', :id => @client.id, :rdrct => 'na_kalimy', :xhr => 'true'
    #    if request.post? and @client.save
    #      flash[:notice] = @client.name+': новый клиент создан.'
    #      
    #    else
    #      render(:layout => 'main') if request.xhr?
    #    end
  end
  
  def editcontact
    contact = Contact.find(params[:id])
    if request.post? and contact.update_attributes(params[:contact])
      redirect_to :controller => params[:cntrl][:name], :action => 'edit', :id => params[:client_id][:id]  
    end
  end
  
  def edit
    @client = Client.find(params[:id])
    @contact = @client.contacts
    if params[:rekvizit_id]
      rekvizits = Rekvizit.find(params[:rekvizit_id][:id]) 
      if request.post? and rekvizits.update_attributes(params[:rekvizit])
        #flash[:notice] = rekvizits.name+': изменения сохранены.'
        redirect_to :controller =>'order', :action => 'status'
      else
        render(:layout => 'main') if request.xhr? or params[:xhr]
      end    
    else
      if request.post? and @client.update_attributes(params[:client])
        
        #flash[:notice] = @client.name+': изменения сохранены.'
        redirect_to :controller =>'order', :action => 'status'
      else
        if params[:from] == 'addcontact'
          render(:layout => false)
        else
          render(:layout => 'main') if request.xhr? or params[:xhr]
        end
      end 
    end
  end
  
  def del
    Client.delete(params[:id])
    render :partial => "app/deldiv", :locals => { :div => "delcl_div_"+params[:id]}
  end
  
  def delcontact
    Contact.delete(params[:id])
    render :partial => "app/deldiv", :locals => { :div => "contact_div_"+params[:id]}
  end
  
  def delphone
    Phone.delete(params[:id])
    render :partial => "app/deldiv", :locals => { :div => 'tel_alldiv_'+params[:id]}
  end
  
  def mainphone
    phone = Phone.find(params[:id])
    if(params[:doing]=='add')
      phone.update_attribute(:visible,'true')
      render :inline => %{ <%= 
              link_to_remote imgadd, :update => 'maintel_div_'+params[:id], :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'client', :action => "mainphone", :id => params[:id], :doing => 'del'}
              %>}      
    else
      phone.update_attribute(:visible,'false')
      render :inline => %{ <%= 
              link_to_remote imgdel, :update => 'maintel_div_'+params[:id], :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'client', :action => "mainphone", :id => params[:id], :doing => 'add'}
              %>}
    end
  end
  
  def maincont
    contact = Contact.find(params[:id])
    if params[:doing]=='add'
      contact.update_attribute(:visible,'true')
      render :inline => %{ <%= 
              link_to_remote(imgadd, :update => 'maincont_div_'+params[:id], :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'client', :action => "maincont", :id => params[:id], :doing => 'del'}) 
              %>}
    else
      contact.update_attribute(:visible,'false')
      render :inline => %{ <%= 
            link_to_remote imgdel, :update => 'maincont_div_'+params[:id], :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => 'get', :url => {:controller =>'client', :action => "maincont", :id => params[:id], :doing => 'add'}
            %>}
    end
  end
  
  def show
    @client = Client.find(params[:id])
    render(:layout => 'main') if request.xhr?
  end
  
  def addcontact
    @contact = Contact.new(params[:contact])
    if params[:cntrl][:name] == 'client'
      @contact.client_id = params[:client_id][:id]
    end
    if params[:cntrl][:name] == 'contractor'
      @contact.contractor_id = params[:client_id][:id]
    end
    if request.post? and @contact.save
      #flash[:notice] = @contact.name+': новый контакт создан.'
      redirect_to :controller => params[:cntrl][:name], :action => 'edit', :id => params[:client_id][:id], :from => 'addcontact', :xhr => '1'
    end
  end

  def addphone
    @phone = Phone.new(params[:phone])
    @phone.contact_id = params[:contact_id][:id]
    if request.post? and @phone.save
      #flash[:notice] = @phone.number+': новый телефон добавлен.'
      redirect_to :controller => params[:cntrl][:name], :action => 'edit', :id => params[:client_id][:id], :from => 'addcontact', :xhr => '1'
    end
  end
 
end
