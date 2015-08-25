module OfficeHelper
  def loadext(m)
    pr = Price.new
    Price.find(:all, :conditions =>{:order_id => session[:order], :banner_id => params[:id], :month => m }).each do |p|
      pr = p if not p.extra_id.nil?
    end
    sel = "нет"
    sel = pr.wtf if (not pr.nil?) and (not pr.wtf.nil?)
    return sel
  end

  def loadinfocontact
    p=@client
    @human = nil
    @icq = nil
    @email = nil
    @mob = nil
    @stac = nil
    @www = nil

    #ids = Array.new()
    #p.contacts.each do |c|
    #    ids[ids.size]=c.id
    #end
    @human = Contact.find(:first, :conditions => {:client_id => p.id, :visible => 'true' }, :select=>'name, id')
    @human = Contact.find(:first, :conditions => {:client_id => p.id }, :select=>'name,id') if @human.nil?

    if @human.nil?
      @human = Contact.new()
      @icq = Phone.new()
      @email = Phone.new()
      @stac = Phone.new()
      @mob = Phone.new()
      @www = Phone.new()

      @human.name = '-'
      @icq.number = '-'
      @email.number = '-'
      @stac.number = '-'
      @mob.number = '-'
      @www.number = '-'
    else
      #ids.each do |s|
      @icq = Phone.find(:first, :conditions =>{:tip => 'icq', :visible => 'true', :contact_id => @human.id})
      @email = Phone.find(:first, :conditions =>{:tip => 'e-mail', :visible => 'true', :contact_id => @human.id})
      @stac = Phone.find(:first, :conditions =>{:tip => 'гор', :visible => 'true', :contact_id => @human.id})
      @mob = Phone.find(:first, :conditions =>{:tip => 'моб', :visible => 'true', :contact_id => @human.id})
      @www = Phone.find(:first, :conditions =>{:tip => 'www', :visible => 'true', :contact_id => @human.id})
      #end
      if @icq.nil?
        @icq = Phone.find(:first, :conditions =>{:tip => 'icq', :contact_id => @human.id})
        if @icq.nil?
          @icq = Phone.new()
          @icq.number = '-'
        end
      end
      if @email.nil?
        @email = Phone.find(:first, :conditions =>{:tip => 'e-mail', :contact_id => @human.id})
        if @email.nil?
          @email = Phone.new()
          @email.number = '-'
        end
      end
      if @stac.nil?
        @stac = Phone.find(:first, :conditions =>{:tip => 'гор', :contact_id => @human.id})
        if @stac.nil?
          @stac = Phone.new()
          @stac.number = '-'
        end
      end
      if @mob.nil?
        @mob = Phone.find(:first, :conditions =>{:tip => 'моб', :contact_id => @human.id})
        if @mob.nil?
          @mob = Phone.new()
          @mob.number = '-'
        end
      end
      if @www.nil?
        @www = Phone.find(:first, :conditions =>{:tip => 'www', :contact_id => @human.id})
        if @www.nil?
          @www = Phone.new()
          @www.number = '-'
        end
      end
    end
  end
end
