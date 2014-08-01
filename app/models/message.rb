class Message < ActiveRecord::Base

  has_access_rules(icon: "fa-envelop-o", path: "/messages", app_name: "caminio", app_is_public: true)


  def attributes
    { title: nil,
      content: nil,
      followup_id: nil,
      id: nil
    }
  end

end
