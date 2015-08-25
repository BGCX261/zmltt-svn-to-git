deldivc
вид:
<tr id="delUSER_div_<%= u.id.to_s%>">
  <td><span id="delUSER_PRE_div_<%= u.id.to_s%>">11111111111111111</td>
  <td><%= deldivc('CONTROLLER', "ACTION", u.id, "delUSER_PRE_div_#{u.id.to_s}", '[x]', текст на подтверждение) %></td>
</tr>

контроллер:
  def ACTION
    #{}Extra.delete(params[:id])
    render :partial => "app/deldiv", :locals => { :div => "delUSER_div_"+params[:id]}
  end

render :partial => "app/deldiv", :locals => { :div => "del_div_"+params[:id]}
id="delXXX_div_<%= p.id.to_s%>"
id="delXXXpre_div_<%= p.id.to_s%>"
<%= deldiv('order', "erasefree", p.id, "delXXXpre_div_#{p.id.to_s}",imgremove) %>

calendarh(txt, cntrl, alt, date = Time.now, doing = 'r', orderid = '0', div = 'main_div', upddiv = 'xz')

  <% @price = Price.find(:first, :conditions => {:banner_id => p.id, :order_id => session[:order]})
  @price.databegin = Time.now.to_date if @price.databegin.nil?
  @price.dataend = Time.now.to_date + 1.month if @price.dataend.nil?
  %>
  
        <td><span id="databeg_<%= @price.id.to_s %>"><%= calendarh(@price.databegin, 'office', 'setrecycler', @price.databegin, 's', @price.id, 'databeg_'+@price.id.to_s) %></span>
          <%#= in_place_editor_field :price, :databegin%></td>
        <td><span id="dataend_<%= @price.id.to_s %>"><%= calendarh(@price.dataend, 'office', 'setrecyclerend', @price.dataend, 's', @price.id, 'dataend_'+@price.id.to_s) %></span>
          <%#= in_place_editor_field :price, 'dataend' %></td>