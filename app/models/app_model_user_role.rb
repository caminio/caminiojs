#
# @Author: David Reinisch
# @Company: TASTENWERK e.U.
# @Copyright: 2014 by TASTENWERK
#
# @Date:   2014-07-25 16:44:58
#
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-25 17:07:56
#
# This source code is not part of the public domain
# If server side nodejs, it is intendet to be read by
# authorized staff, collaborator or legal partner of
# TASTENWERK only

class AppModelUserRole < ActiveRecord::Base
  belongs_to :user 
  belongs_to :app_model
  belongs_to :organizational_unit
end