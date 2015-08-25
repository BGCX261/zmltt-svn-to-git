class ContractorController < ApplicationController
  include AuthenticatedSystem
  protect_from_forgery :only => [:chid]
  
  before_filter :login_from_cookie
  before_filter :login_required
  in_place_edit_for :contact, :name
  in_place_edit_for :contact, :post
  in_place_edit_for :phone, :number
  in_place_edit_for :contractor, :zametka

  def index
    @contractors = Contractor.find(:all, :order => 'id DESC').reverse!
  end
  
  def chid
    @contractor = Contractor.find(params[:id])
    if @contractor.update_attribute('nid',params[:nid].to_i)
      render :text => params[:nid]
    else
      render :text =>' params[:nid]'
    end
  end
  
  def add
    if current_user.login == 'zm-admin'
      @contractor = Contractor.new
      @contractor.nid = (Contractor.find(:all).size+1).to_s
      @contractor.save!
      if params[:format]=='xml'
        render :text => @contractor.id
      else
        cont = Contact.new
        cont.contractor_id = @contractor.id
        cont.save!
        redirect_to :action => 'edit', :id => @contractor.id.to_s#, :xhr => '1'
      end
    end
  end

  def add_contact
    if current_user.login == 'zm-admin'
      contact = Contact.new
      contact.contractor_id = params[:id]     
      contact.name='Новая визитка'
      contact.save!
      render :text => contact.id
    end
  end
  
  def del_contact
    if current_user.login == 'zm-admin'
      Contact.delete(params[:id]) if params[:type]=='contact'
      Phone.delete(params[:id]) if params[:type]=='phone'
      render :text => 'ok'
    else
      render :text => 'пнх'
    end
  end

  def edit
    if current_user.login == 'zm-admin'
      if params[:format]=='xml'
        begin  
          @contractor = Contractor.find(params[:id])
          @contractor.update_attributes(params[:contractor])
          save_contacts()
          render :text => 'ok' #params['c'+0.to_s][:visible]#'ok'#params[:c0][:name].to_xml
        rescue Exception => e  
          render :text => e.message + e.backtrace.inspect  
          #puts e.backtrace.inspect  
        end
        
      else
        @contractor = Contractor.find(params[:id])
        if request.post? and @contractor.update_attributes(params[:contractor])
          #flash[:notice] = @contractor.name+': изменения сохранены.'
          redirect_to :action => 'index'
        else
          if params[:from] == 'addcontact'
            render(:layout => false)
          else
            render(:layout => 'main') if request.xhr? or params[:xhr]
          end
        end
      end
    end
  end
  
  def del
    if current_user.login == 'zm-admin'
      Contractor.delete(params[:id])
      #flash[:notice] = "Объект удален"
      if params[:format]=='xml'
        render :text => 'ok'
      else
      render :partial => "app/deldiv", :locals => { :div => "delcl_div_"+params[:id]}
      end
    end
  end
  
  def show
    @contractor = Contractor.find(params[:id])
    render(:layout => 'main') if request.xhr?
  end
end
