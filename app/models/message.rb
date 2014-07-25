class Message < ActiveRecord::Base

  has_access_rules(icon: "fa-envelop-o", path: "/messages")

end
