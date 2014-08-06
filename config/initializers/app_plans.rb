unless ( File.basename($0) == 'rake')

  app = App.find_or_create_by name: "caminio" do |a|
    a.position = 0
    a.is_public = true
  end

  puts "here app plan"
  AppPlan.find_or_create_by name: "caminio Basic" do |app_plan|
    app_plan.price = 0
    app_plan.visible = true
    app_plan.app_id = app.id
    app_plan.user_quota = 0
    app_plan.disk_quota = 0
    app_plan.content_quota = 0
    app_plan.translations.build title: "caminio Basic", locale: 'de'
    app_plan.translations.build title: "caminio Basic", locale: 'en'
  end

end
