class Translation < ActiveRecord::Base
  belongs_to :row, polymorphic: true
  belongs_to :creator, class_name: 'User', foreign_key: :created_by
  belongs_to :updater, class_name: 'User', foreign_key: :updated_by

  validates_presence_of :row, :locale
  before_create :check_if_locale_exists

  private 

    def check_if_locale_exists  
      existing_translation = Translation.where( :locale => self.locale, :row => self.row ).load
      if existing_translation.size > 0
        raise StandardError.new("Object already has a translation with this locale") 
      end
    end
    
end
