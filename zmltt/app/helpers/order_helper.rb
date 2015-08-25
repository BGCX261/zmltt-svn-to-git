module OrderHelper
  def wtfuser(id)
        if id.nil? or not User.exists?(id)
          tmpuser = User.new;
          tmpuser.fio = "Не существует";
          tmpuser.phone="нет";
        else
          tmpuser = User.find(id)
        end
        return tmpuser;
  end

  def wtfclient(id)
    if id.nil? or not Client.exists?(id)
      return "---"
    else
      return lnkcl(Client.find(id).name, id)
    end
    
  end
end
