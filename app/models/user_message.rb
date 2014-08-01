#!/usr/bin/ruby
# @Author: David Reinisch
# @Date:   2014-08-01 10:13:28
# @Last Modified by:   David Reinisch
# @Last Modified time: 2014-08-01 10:14:07

class UserMessage < ActiveRecord::Base

  belongs_to :user  
  belongs_to :message
  
end