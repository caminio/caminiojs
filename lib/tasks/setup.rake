require File::expand_path '../rake_colors', __FILE__

namespace :caminio do

  desc "setup app plans"
  task setup: :environment do

    include Colors
    app = App.new
    %w(en de).each do |locale|
      I18n.with_locale(locale) do
        app.write_attributes name: I18n.t('app.core.title'), 
          description: I18n.t('app.core.description'), 
          position: 0
      end
    end
    app_plan = app.app_plans.build
    %w(en de).each do |locale|
      I18n.with_locale(locale) do
        app_plan.write_attributes name: I18n.t('app.core.plan.free.title'), 
          users_quota: 2,
          content_quota: 1000,
          disk_quota: 10
      end
    end
    app_plan = app.app_plans.build
    %w(en de).each do |locale|
      I18n.with_locale(locale) do
        app_plan.write_attributes name: I18n.t('app.core.plan.collaboration.title'), 
          users_quota: 5,
          content_quota: 10000,
          disk_quota: 100
      end
    end

    app.save

    puts "[caminio] #{green app.name} created"

  end

end
