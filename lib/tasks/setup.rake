require 'colorize'

namespace :caminio do

  desc "setup app plans"
  task setup: :environment do

    app = App.new name: 'core'
    %w(en de).each do |locale|
      I18n.with_locale(locale) do
        app.write_attributes title: I18n.t('app.core.title'), 
          description: I18n.t('app.core.description'),
          position: 0,
          icon: 'fa-home',
          url: '/caminio'
      end
    end
    unless app.save
      puts "[caminio] #{app.name.red} aborted. due: #{app.errors.full_messages.inspect}" 
      next
    end

    app_plan = app.app_plans.create user_quota: 2,
      content_quota: 1000,
      disk_quota: 10,
      hidden: false,
      name: 'free'
    %w(en de).each do |locale|
      I18n.with_locale(locale) do
        app_plan.write_attributes title: I18n.t('app.core.plan.free.title')
      end
    end
    app_plan.save


    app_plan = app.app_plans.create user_quota: 5,
      content_quota: 10000,
      disk_quota: 100,
      hidden: false,
      name: 'collaboration'
    %w(en de).each do |locale|
      I18n.with_locale(locale) do
        app_plan.write_attributes title: I18n.t('app.core.plan.collaboration.title')
      end
    end
    app_plan.save

    puts "[caminio] #{app.name.green} created"

  end

end
