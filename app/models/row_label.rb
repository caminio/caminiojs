#
# @Author: David Reinisch
# @Company: TASTENWERK e.U.
# @Copyright: 2014 by TASTENWERK
#
# @Date:   2014-07-23 14:17:20
#
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-24 17:22:51
#
# This source code is not part of the public domain
# If server side nodejs, it is intendet to be read by
# authorized staff, collaborator or legal partner of
# TASTENWERK only
class RowLabel < ActiveRecord::Base
  belongs_to :row, polymorphic: true
  belongs_to :label
end
