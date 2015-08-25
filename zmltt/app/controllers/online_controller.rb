class OnlineController < ApplicationController
  $KCODE = 'u'
  require 'jcode'
  include AuthenticatedSystem
  before_filter :login_from_cookie

  def setonline
    session[:onlinepos] = 'online' if params[:onlinepos] == 'online'
    session[:onlinepos] = 'all' if params[:onlinepos] == 'all'
    if session[:search].nil? or session[:search].size < 1
      session[:search] = '1'
      showalltips
    end
    params[:search] = session[:search]
    findbanners()
    render :layout=>false
  end

  def online
    if request.post?
      onlinebdwin = params[:online][:online_data].read
      msv = Array.new
      contr = String.new
      perc = String.new
      ident = 0
      @howmach = Banner.find(:all, :conditions =>{:online =>'есть'}).size

      ic = Iconv.new('UTF-8','WINDOWS-1251')
      onlinebdutf = ic.iconv(onlinebdwin)
      onlinebdutf.split("\n").each do |on|
        msv = on.split("\t")
        if msv[1]!~/\d+/ and msv[2]!~/\d+/
          contr = msv[0]
          perc = msv[3]
          ident = Contractor.find(:first, :conditions => {:nid => contr}).id if not Contractor.find(:first,:conditions => {:nid => contr}).nil?
          Banner.find(:all, :conditions => {:contractor_id => ident, :online => "есть"}).each do |b|
            b.update_attribute(:online, "нет")
            b.onlines.delete_all
          end
        else
          if not Banner.find(:first, :conditions => {:contractor_id => ident, :xnomer => msv[0] }).nil?
            banner = Banner.find(:first, :conditions => {:contractor_id => ident, :xnomer => msv[0] })
            banner.update_attribute(:online, "есть")
            #i = msv.size - 1
            #@howmach += 1
            #while i>0
            online = Online.new
            online.banner_id = banner.id
            online.realcoast = msv[3].delete(' ').delete('р.').to_i
            online.coast = online.realcoast.to_i+online.realcoast.to_i*perc.to_i/100
            online.coast = (online.coast.to_i/100).to_s;
            online.coast = (online.coast.to_i*100).to_s;
            online.databegin = msv[1].to_date
            online.dataend = msv[2].to_date
            online.save! #if msv[i].size > 1
            # i -= 2
            #end
          end
        end
      end
      @howmach = Banner.find(:all, :conditions =>{:online =>'есть'}).size - @howmach
      #render :text => @howmach.to_s + " поверхностей обновлено"
    end
  end

  def erase
    Online.delete_all
    Banner.find(:all, :conditions => {:online => "есть"}).each do |b|
      b.update_attribute(:online, "нет")
    end
    redirect_to :action => 'upload'
  end

  def upload
    #podrs = Contractor.find(:all, :order=> "name", :select => 'name')
    #@podr=Array.new()
    #podrs.each do |p|
    #  @podr[@podr.size] = p.name if p.name
    #end
    #@podr.uniq!
  end


end
