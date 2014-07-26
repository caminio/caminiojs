#
# @Author: David Reinisch
# @Company: TASTENWERK e.U.
# @Copyright: 2014 by TASTENWERK
#
# @Date:   2014-07-25 18:05:08
#
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-07-25 18:07:02
#
# This source code is not part of the public domain
# If server side nodejs, it is intendet to be read by
# authorized staff, collaborator or legal partner of
# TASTENWERK only

module Caminio 
  module Access
    NONE  = 0
    READ  = 1
    WRITE = 2
    SHARE = 3
    FULL  = 4
  end
end