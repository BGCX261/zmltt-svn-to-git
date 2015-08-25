class SpecController < ApplicationController
  protect_from_forgery :except => [:new, :create, :show, :list]
  include AuthenticatedSystem
  before_filter :login_from_cookie
  #before_filter :login_required, :except => [:fademain, :set_price_size, :show, :index, :file_id, :livesearch, :recycler, :tip, :showall] 
  before_filter :login_required, :only => [:index] 
  
  def new
	#params[:special][:uploaded_data] = params[:Filedata] if params[:Filedata] 
	#params[:special][:filename] = params[:Filename] if params[:Filename]
    @special = Special.new(params[:special])
	if request.post? and @special.save!
		#File.open('test.txt', 'w') do |f2|  
			# use "\n" for two lines of text  
			#f2.puts params.join(';')
		#end  
		render :text => '', :status => 200
		
	#else
	#	render :text => 'error'
	end
  end
  
  def show
    @special = Special.find(params[:id])
    send_data @special.db_file.data, :type => @special.content_type, :filename => @special.filename, :disposition => 'inline'
  end

  def del
	Special.delete(params[:id])
	render :text => 'ok'
  end

  def list
    @specials = Special.find(:all)
  end
end
